import 'package:action_slider/action_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/orders/domain/usecases/order_usecase.dart';
import 'package:restaurant_app/features/orders/presentation/state/orders_state.dart';

import '../../../../core/common/widgets/food_item/food_item_view_model.dart';
import '../../domain/entity/order_entity.dart';

final ordersViewModelProvider =
    StateNotifierProvider<OrdersViewModel, OrdersState>(
        (ref) => OrdersViewModel(
              ref.read(orderUseCaseProvider),
            ));

class OrdersViewModel extends StateNotifier<OrdersState> {
  OrdersViewModel(
    this._orderUseCase,
  ) : super(OrdersState.initialState([], [])) {
    getAllOrders();
  }

  final OrderUseCase _orderUseCase;

  Future<void> getAllOrders() async {
    state = state.copyWith(isLoading: true);
    _orderUseCase.getAllLocalOrders().then((value) {
      value.fold((l) {
        null;
      }, (r) {
        state = state.copyWith(localOrders: r);
        if (r.isEmpty || r == []) {
          state = state.copyWith(disabled: true);
        } else {
          state = state.copyWith(disabled: false);
        }
      });
    });
    _orderUseCase.getAllRemoteOrders().then((value) {
      value.fold((l) {
        null;
      }, (r) {
        state = state.copyWith(
          remoteOrders: r,
        );
      });
    });
    state = state.copyWith(isLoading: false);
  }

  Future<void> clearLocalOrders(WidgetRef ref) async {
    _orderUseCase.clearLocalOrders().then(
          (value) => value.fold((l) => null, (r) {
            for (var order in r) {
              ref
                  .read(foodItemViewModelProvider(order.food.foodId).notifier)
                  .clear();
            }
            resetState([]);
          }),
        );
  }

  Future<void> clearRemoteOrders(WidgetRef ref) async {
    _orderUseCase.clearRemoteOrders();
    state = state.copyWith(localOrders: [], remoteOrders: []);
  }

  Future<void> confirmOrder(
      ActionSliderController controller, WidgetRef ref) async {
    controller.loading();
    var success = true;
    List<OrderEntity> newRemoteOrders = state.remoteOrders;
    await _orderUseCase.addOrder(state.localOrders).then(
          (value) => value.fold(
            (l) => success = false,
            (r) {
              for (var order in state.localOrders) {
                newRemoteOrders
                    .add(order.copyWith(entity: order, status: 'ORDERED'));
                ref
                    .read(foodItemViewModelProvider(order.food.foodId).notifier)
                    .clear();
              }
            },
          ),
        );
    if (success) {
      controller.success();
    } else {
      controller.failure();
    }
    await Future.delayed(const Duration(seconds: 1));
    controller.reset();
    if (success) {
      state = state.copyWith(
          localOrders: [], remoteOrders: newRemoteOrders, disabled: true);
    }
  }

  void monitorAlertDialogue(bool isShown) {
    state = state.copyWith(isMessageShown: isShown);
  }

  void resetState(List<OrderEntity> unordered) {
    state = OrdersState.initialState(unordered, state.remoteOrders);
  }

  double countTotal() {
    double total = 0;
    for (var order in state.localOrders) {
      total = total + (order.food.foodPrice * order.quantity);
    }
    for (var order in state.remoteOrders) {
      total = total + (order.food.foodPrice * order.quantity);
    }
    return total;
  }

  Future<void> checkout(String status) async {
    await _orderUseCase.checkout(status);
    if (status == 'CASH'){
      state = state.copyWith(payment: Payment.requested);
    }
  }
}
