import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:restaurant_app/core/common/widgets/food_item/food_item_state.dart';
import 'package:restaurant_app/features/favourites/domain/usecases/favourites_usecase.dart';
import 'package:restaurant_app/features/menu/presentation/viewmodel/menu_view_model.dart';
import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/usecases/order_usecase.dart';
import 'package:restaurant_app/features/orders/presentation/viewmodel/orders_view_model.dart';

final foodItemViewModelProvider =
    StateNotifierProvider.family<FoodItemViewModel, FoodItemState, String?>(
        (ref, foodItemId) {
  OrderEntity? matchedOrder;
  bool isFavourite = false;
  bool isOrdered = false;
  String? orderId;
  int quantity = 1;

  try {
    matchedOrder = ref.read(menuViewModelProvider).orders.firstWhere(
          (element) => element.food.foodId == foodItemId,
        );
  } on StateError {
    matchedOrder = null;
  }

  for (var food in ref.watch(menuViewModelProvider).favourites) {
    if (foodItemId == food.foodId) {
      isFavourite = true;
      break;
    }
  }

  if (matchedOrder != null) {
    isOrdered = true;
    orderId = matchedOrder.orderId!;
    quantity = matchedOrder.quantity;
  }

  return FoodItemViewModel(
    foodItemId: foodItemId,
    orderUseCase: ref.read(orderUseCaseProvider),
    favouritesUseCase: ref.read(favouritesUseCaseProvider),
    ordersViewModel: ref.read(ordersViewModelProvider.notifier),
    isOrdered: isOrdered,
    isFavourite: isFavourite,
    orderId: orderId,
    quantity: quantity,
  );
});

class FoodItemViewModel extends StateNotifier<FoodItemState> {
  final OrderUseCase orderUseCase;
  final FavouritesUseCase favouritesUseCase;
  final OrdersViewModel ordersViewModel;
  final bool isOrdered;
  final bool isFavourite;
  final String? orderId;
  final int quantity;

  FoodItemViewModel(
      {String? foodItemId,
      required this.orderUseCase,
      required this.ordersViewModel,
      required this.favouritesUseCase,
      required this.isOrdered,
      required this.isFavourite,
      this.orderId,
      required this.quantity})
      : super(FoodItemState.initialState(
          isOrdered: isOrdered,
          isFavourite: isFavourite,
          orderId: orderId,
          quantity: quantity,
        ));

  void increment() async {
    if (state.quantity < 20) {
      state = state.copyWith(quantity: state.quantity + 1);
    }
  }

  void decrement() async {
    if (state.quantity > 1) {
      state = state.copyWith(quantity: state.quantity - 1);
    }
  }

  void localOrder(GifController controller, OrderEntity order) async {
    state = state.copyWith(isLoading: true);
    orderUseCase.addOrderLocally(order).then(
          (value) => value.fold(
            (l) {
              state = state.copyWith(isLoading: false);
            },
            (r) {
              state = state.copyWith(
                  isOrdered: !state.isOrdered, orderId: r, isLoading: false);
              controller.seek(0);
              controller.play();
            },
          ),
        );
    ordersViewModel.getAllOrders();
  }

  void removeOrder({required String key, GifController? controller}) async {
    state = state.copyWith(isLoading: true, quantity: 1);
    orderUseCase.removeOrder(key).then((value) => value.fold((l) {
          state = state.copyWith(isLoading: false);
        }, (r) {
          state = state.copyWith(
              isOrdered: !state.isOrdered, orderId: null, isLoading: false);
          if (controller != null) {
            controller.seek(0);
            controller.play();
          }
        }));
    ordersViewModel.getAllOrders();
  }

  void favourite(String foodId) async {
    state = state.copyWith(isFavourite: !state.isFavourite);
    favouritesUseCase
        .editFavourites(add: state.isFavourite, foodId: foodId)
        .then((value) => value.fold((l) {
      state = state.copyWith(isFavourite: !state.isFavourite);
    }, (r) => null));
  }

  void clear() {
    state = state.copyWith(isOrdered: false, quantity: 1, orderId: null);
  }
}
