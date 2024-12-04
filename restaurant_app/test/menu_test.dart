import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:restaurant_app/features/favourites/domain/usecases/favourites_usecase.dart';
import 'package:restaurant_app/features/home/home_state.dart';
import 'package:restaurant_app/features/menu/domain/entity/category_entity.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';
import 'package:restaurant_app/features/menu/domain/usecases/menu_usecase.dart';
import 'package:restaurant_app/features/menu/presentation/viewmodel/menu_view_model.dart';
import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/usecases/order_usecase.dart';

import 'menu_test.mocks.dart';

@GenerateMocks([MenuUseCase, OrderUseCase, FavouritesUseCase, HomeState])
void main() {
  late MenuViewModel menuViewModel;
  late MockMenuUseCase mockMenuUseCase;
  late MockOrderUseCase mockOrderUseCase;
  late MockFavouritesUseCase mockFavouritesUseCase;
  late MockHomeState mockHomeState;

  setUp(() {
    mockMenuUseCase = MockMenuUseCase();
    mockOrderUseCase = MockOrderUseCase();
    mockFavouritesUseCase = MockFavouritesUseCase();
    mockHomeState = MockHomeState();
    menuViewModel = MenuViewModel(
      menuUseCase: mockMenuUseCase,
      orderUseCase: mockOrderUseCase,
      favouritesUseCase: mockFavouritesUseCase,
      homeState: mockHomeState,
      node: FocusNode(),
    );
  });

  test('getAllCategories - Success', () async {
    final categories = [const CategoryEntity(categoryName: 'Category 1', categoryImageUrl: '', status: true, categoryId: '1')];
    when(mockMenuUseCase.getAllCategories())
        .thenAnswer((_) async => Right(categories));
    when(mockMenuUseCase.getSelectedFood('1'))
        .thenAnswer((_) async => const Right([]));

    await menuViewModel.getAllCategories();

    expect(menuViewModel.state.isCategoriesLoading, false);
    expect(menuViewModel.state.categories, categories);
    verify(mockMenuUseCase.getSelectedFood('1')).called(1);
  });

  test('getAllCategories - Failure', () async {
    final failure = Failure(error: 'Failed to fetch categories');
    when(mockMenuUseCase.getAllCategories())
        .thenAnswer((_) async => Left(failure));

    await menuViewModel.getAllCategories();

    expect(menuViewModel.state.isCategoriesLoading, false);
    expect(menuViewModel.state.categories.isEmpty, true);
  });

  test('getSearchedFood - Success', () async {
    const query = 'food';
    final food = [const FoodEntity(foodName: 'food', foodImageUrl: '', foodPrice: 0, foodTime: 0)];
    when(mockMenuUseCase.getSearchedFood(query))
        .thenAnswer((_) async => Right(food));

    await menuViewModel.getSearchedFood(query);

    expect(menuViewModel.state.isSearchLoading, false);
    expect(menuViewModel.state.searchResults, food);
  });

  test('getSearchedFood - Failure', () async {
    const query = 'food';
    final failure = Failure(error: 'Failed to search food');
    when(mockMenuUseCase.getSearchedFood(query))
        .thenAnswer((_) async => Left(failure));

    await menuViewModel.getSearchedFood(query);

    expect(menuViewModel.state.isSearchLoading, false);
    expect(menuViewModel.state.searchResults.isEmpty, true);
  });

  test('getOrderedFood - Success', () async {
    final orders = [const OrderEntity(food: FoodEntity(foodName: 'food', foodImageUrl: '', foodPrice: 0, foodTime: 0), quantity: 1, status: '')];
    when(mockOrderUseCase.getAllLocalOrders())
        .thenAnswer((_) async => Right(orders));

    await menuViewModel.getOrderedFood();

    expect(menuViewModel.state.orders, orders);
  });

  test('getOrderedFood - Failure', () async {
    final failure = Failure(error: 'Failed to fetch ordered food');
    when(mockOrderUseCase.getAllLocalOrders())
        .thenAnswer((_) async => Left(failure));

    await menuViewModel.getOrderedFood();

    expect(menuViewModel.state.orders.isEmpty, true);
  });

  test('getFavourites - Success', () async {
    // Arrange
    final favourites = [const FoodEntity(foodName: 'food', foodImageUrl: '', foodPrice: 0, foodTime: 0)];
    when(mockFavouritesUseCase.getFavourites())
        .thenAnswer((_) async => Right(favourites));

    // Act
    await menuViewModel.getFavourites();

    // Assert
    expect(menuViewModel.state.favourites, favourites);
  });

  test('getFavourites - Failure', () async {
    final failure = Failure(error: 'Failed to fetch favourites');
    when(mockFavouritesUseCase.getFavourites())
        .thenAnswer((_) async => Left(failure));

    // Act
    await menuViewModel.getFavourites();

    // Assert
    expect(menuViewModel.state.favourites.isEmpty, true);
  });

  test('unFocus', () {
    menuViewModel.unFocus();
    expect(menuViewModel.state.isSearchFocused, false);
    expect(menuViewModel.state.searchResults.isEmpty, true);
  });

  test('resetState', () async {
    await menuViewModel.resetState();
    expect(menuViewModel.state.categories.isEmpty, true);
  });
}
