import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';
import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/usecases/order_usecase.dart';
import 'package:restaurant_app/features/orders/presentation/state/orders_state.dart';
import 'package:restaurant_app/features/orders/presentation/viewmodel/orders_view_model.dart';

import 'orders_test.mocks.dart';

@GenerateMocks([OrderUseCase])
void main() {
  late OrdersViewModel ordersViewModel;
  late MockOrderUseCase mockOrderUseCase;

  setUp(() {
    mockOrderUseCase = MockOrderUseCase();
    ordersViewModel = OrdersViewModel(mockOrderUseCase);
  });

  test('getAllOrders - Success', () async {
    final localOrders = [const OrderEntity(food: FoodEntity(foodName: 'food', foodImageUrl: '', foodPrice: 0, foodTime: 0), quantity: 1, status: '')];
    final remoteOrders = [const OrderEntity(food: FoodEntity(foodName: 'food', foodImageUrl: '', foodPrice: 0, foodTime: 0), quantity: 1, status: '')];
    when(mockOrderUseCase.getAllLocalOrders())
        .thenAnswer((_) async => Right(localOrders));
    when(mockOrderUseCase.getAllRemoteOrders())
        .thenAnswer((_) async => Right(remoteOrders));

    await ordersViewModel.getAllOrders();

    expect(ordersViewModel.state.localOrders, localOrders);
    expect(ordersViewModel.state.remoteOrders, remoteOrders);
    expect(ordersViewModel.state.isLoading, false);
  });

  test('getAllOrders - Failure', () async {
    final failure = Failure(error: 'Failed to fetch orders');
    when(mockOrderUseCase.getAllLocalOrders())
        .thenAnswer((_) async => Left(failure));
    when(mockOrderUseCase.getAllRemoteOrders())
        .thenAnswer((_) async => Left(failure));

    await ordersViewModel.getAllOrders();

    expect(ordersViewModel.state.localOrders, []);
    expect(ordersViewModel.state.remoteOrders, []);
    expect(ordersViewModel.state.isLoading, false);
  });

  test('monitorAlertDialogue', () {
    const isShown = true;
    ordersViewModel.monitorAlertDialogue(isShown);
    expect(ordersViewModel.state.isMessageShown, isShown);
  });

  test('resetState', () {
    final unordered = [const OrderEntity(food: FoodEntity(foodName: 'food', foodImageUrl: '', foodPrice: 0, foodTime: 0), quantity: 1, status: '')];
    final initialState = OrdersState.initialState(unordered, []);

    ordersViewModel.resetState(unordered);

    expect(ordersViewModel.state.localOrders, unordered);
    expect(ordersViewModel.state.remoteOrders, initialState.remoteOrders);
  });

  test('countTotal', () {
    // Arrange
    final localOrders = [
      const OrderEntity(food: FoodEntity(foodName: 'food', foodImageUrl: '', foodPrice: 10, foodTime: 0), quantity: 1, status: ''),
      const OrderEntity(food: FoodEntity(foodName: 'food', foodImageUrl: '', foodPrice: 20, foodTime: 0), quantity: 1, status: '')
    ];
    final remoteOrders = [
      const OrderEntity(food: FoodEntity(foodName: 'food', foodImageUrl: '', foodPrice: 30, foodTime: 0), quantity: 1, status: ''),
      const OrderEntity(food: FoodEntity(foodName: 'food', foodImageUrl: '', foodPrice: 40, foodTime: 0), quantity: 1, status: ''),
    ];
    ordersViewModel.state = OrdersState(
      localOrders: localOrders,
      remoteOrders: remoteOrders,
      isLoading: false,
      isMessageShown: false,
      disabled: false,
      payment: Payment.notPaid,
    );

    final total = ordersViewModel.countTotal();

    expect(total, 10 * 1 + 20 * 1 + 30 * 1 + 40 * 1);
  });

  test('checkout - CASH payment', () async {
    const status = 'CASH';
    when(mockOrderUseCase.checkout(status))
        .thenAnswer((_) async => const Right(true));

    await ordersViewModel.checkout(status);

    expect(ordersViewModel.state.payment, Payment.requested);
  });

  test('checkout - ONLINE payment', () async {
    const status = 'OTHER';
    when(mockOrderUseCase.checkout(status))
        .thenAnswer((_) async => const Right(true));

    await ordersViewModel.checkout(status);

    expect(ordersViewModel.state.payment, Payment.notPaid);
  });
}
