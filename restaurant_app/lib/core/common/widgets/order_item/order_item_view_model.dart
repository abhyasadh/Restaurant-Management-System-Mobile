import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/usecases/order_usecase.dart';
import 'package:restaurant_app/features/orders/presentation/state/orders_state.dart';
import 'package:restaurant_app/features/orders/presentation/viewmodel/orders_view_model.dart';

import '../food_item/food_item_view_model.dart';
import 'order_item_state.dart';

final orderItemViewModelProvider = StateNotifierProvider.family<
    OrderItemViewModel, OrderItemState, OrderEntity>((ref, order) {
  return OrderItemViewModel(
      order: order,
      orderState: ref.read(ordersViewModelProvider),
      ordersViewModel: ref.read(ordersViewModelProvider.notifier),
      orderUseCase: ref.read(orderUseCaseProvider),
      foodItemViewModel:
          ref.read(foodItemViewModelProvider(order.food.foodId).notifier));
});

class OrderItemViewModel extends StateNotifier<OrderItemState> {
  final OrdersState orderState;
  final OrdersViewModel ordersViewModel;
  final OrderUseCase orderUseCase;
  final FoodItemViewModel foodItemViewModel;
  final OrderEntity order;

  OrderItemViewModel(
      {required this.orderState,
      required this.order,
      required this.ordersViewModel,
      required this.orderUseCase,
      required this.foodItemViewModel})
      : super(
          OrderItemState.initialState(
            ordered: order.status == 'ORDERED',
            quantity: order.quantity,
          ),
        );

  void increment() async {
    if (state.quantity < 20 && !state.isLoading) {
      state = state.copyWith(isLoading: true);
      await orderUseCase.getLocalOrder(order.orderId!).then(
            (value) => value.fold(
              (fail) => null,
              (order) {
                OrderEntity newOrder = OrderEntity(
                  orderId: order.orderId,
                  food: order.food,
                  quantity: state.quantity + 1,
                  status: order.status,
                );
                orderUseCase.addOrderLocally(newOrder);
              },
            ),
          );
      List<OrderEntity> newOrder = orderState.localOrders;
      for (int i = 0; i < newOrder.length; i++) {
        if (newOrder[i].orderId == order.orderId) {
          newOrder[i] = newOrder[i]
              .copyWith(entity: newOrder[i], quantity: state.quantity + 1);
        }
      }
      ordersViewModel.resetState(newOrder);
      foodItemViewModel.increment();
      state = state.copyWith(isLoading: false);
    }
  }

  void decrement() async {
    if (state.quantity > 1 && !state.isLoading) {
      state = state.copyWith(
        isLoading: true,
      );
      await orderUseCase.getLocalOrder(order.orderId!).then(
            (value) => value.fold((fail) => null, (order) {
              OrderEntity newOrder = OrderEntity(
                orderId: order.orderId,
                food: order.food,
                quantity: state.quantity - 1,
                status: order.status,
              );
              orderUseCase.addOrderLocally(newOrder);
            }),
          );
      List<OrderEntity> newOrder = orderState.localOrders;
      for (int i = 0; i < newOrder.length; i++) {
        if (newOrder[i].orderId == order.orderId) {
          newOrder[i] = newOrder[i]
              .copyWith(entity: newOrder[i], quantity: state.quantity - 1);
        }
      }
      ordersViewModel.resetState(newOrder);
      foodItemViewModel.decrement();
      state = state.copyWith(
        isLoading: false,
      );
    }
  }

  void removeOrder() async {
    foodItemViewModel.removeOrder(key: order.orderId!);
    List<OrderEntity> orders = orderState.localOrders;
    orders.remove(order);
    ordersViewModel.resetState(orders);
  }
}
