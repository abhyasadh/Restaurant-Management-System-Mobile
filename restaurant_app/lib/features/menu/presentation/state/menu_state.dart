import 'package:flutter/material.dart';
import 'package:restaurant_app/features/menu/domain/entity/category_entity.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';
import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';

class MenuState {
  final bool isCategoriesLoading;
  final bool isFoodLoading;
  final List<CategoryEntity> categories;
  final List<List<FoodEntity>> allFood;
  final List<FoodEntity> displayFood;
  final int selectedCategory;

  final List<OrderEntity> orders;
  final List<FoodEntity> favourites;

  final Color searchIconColor;
  final bool isSearchFocused;
  final bool isSearchLoading;
  final List<FoodEntity> searchResults;

  final String name;

  final String? error;

  MenuState({
    required this.isCategoriesLoading,
    required this.isFoodLoading,
    required this.categories,
    required this.allFood,
    required this.displayFood,
    required this.selectedCategory,

    required this.orders,
    required this.favourites,

    required this.searchIconColor,
    required this.isSearchFocused,
    required this.isSearchLoading,
    required this.searchResults,

    required this.name,

    this.error,
  });

  factory MenuState.initialState() {
    return MenuState(
      isCategoriesLoading: false,
      isFoodLoading: false,
      name: '',
      selectedCategory: 0,
      categories: [],
      allFood: [],
      displayFood: [],
      orders: [],
      favourites: [],
      searchIconColor: Colors.grey,
      isSearchFocused: false,
      isSearchLoading: false,
      searchResults: [],
      error: null,
    );
  }

  MenuState copyWith({
    bool? isCategoriesLoading,
    bool? isFoodLoading,
    String? name,
    int? selectedCategory,
    List<CategoryEntity>? categories,
    List<List<FoodEntity>>? allFood,
    List<FoodEntity>? displayFood,
    List<OrderEntity>? orders,
    List<FoodEntity>? favourites,
    Color? searchIconColor,
    bool? isSearchFocused,
    bool? isSearchLoading,
    List<FoodEntity>? searchResults,
    String? error,
  }) {
    return MenuState(
        isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
        isFoodLoading: isFoodLoading ?? this.isFoodLoading,
        name: name ?? this.name,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        categories: categories ?? this.categories,
        allFood: allFood ?? this.allFood,
        displayFood: displayFood ?? this.displayFood,
        error: error ?? this.error,
        orders: orders ?? this.orders,
        favourites: favourites ?? this.favourites,
        searchIconColor: searchIconColor ?? this.searchIconColor,
        isSearchFocused: isSearchFocused ?? this.isSearchFocused,
        isSearchLoading: isSearchLoading ?? this.isSearchLoading,
        searchResults: searchResults ?? this.searchResults);
  }
}
