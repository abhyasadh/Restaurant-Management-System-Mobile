import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/favourites/domain/usecases/favourites_usecase.dart';
import 'package:restaurant_app/features/home/home_view_model.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';
import 'package:restaurant_app/features/menu/domain/usecases/menu_usecase.dart';
import 'package:restaurant_app/features/menu/presentation/state/menu_state.dart';
import 'package:restaurant_app/features/orders/domain/usecases/order_usecase.dart';

import '../../../home/home_state.dart';

final menuViewModelProvider = StateNotifierProvider<MenuViewModel, MenuState>(
  (ref) => MenuViewModel(
    menuUseCase: ref.read(menuUseCaseProvider),
    orderUseCase: ref.read(orderUseCaseProvider),
    favouritesUseCase: ref.read(favouritesUseCaseProvider),
    homeState: ref.read(homeViewModelProvider),
    node: FocusNode(),
  ),
);

class MenuViewModel extends StateNotifier<MenuState> {
  final MenuUseCase menuUseCase;
  final OrderUseCase orderUseCase;
  final FavouritesUseCase favouritesUseCase;
  final HomeState homeState;
  final FocusNode node;

  MenuViewModel(
      {required this.menuUseCase,
      required this.orderUseCase,
      required this.homeState,
      required this.favouritesUseCase,
      required this.node})
      : super(MenuState.initialState()) {
    getAllCategories();
    getOrderedFood();
    getFavourites();
    init();

    node.addListener(() {
      if (node.hasFocus) {
        state = state.copyWith(
            searchIconColor: const Color(0xffff6c44), isSearchFocused: true);
      } else {
        state = state.copyWith(
          searchIconColor: Colors.grey,
        );
      }
    });
  }

  init() => state = state.copyWith(name: homeState.userData[1]);

  Future getAllCategories() async {
    state = state.copyWith(isCategoriesLoading: true);
    menuUseCase.getAllCategories().then((value) {
      value.fold(
        (failure) {
          state = state.copyWith(isCategoriesLoading: false);
        },
        (categories) {
          state = state.copyWith(
            isCategoriesLoading: false,
            categories: categories,
            allFood: List.generate(categories.length, (index) => []),
          );
          getFoodByCategory(categories[state.selectedCategory].categoryId!,
              state.selectedCategory);
        },
      );
    });
  }

  Future getFoodByCategory(String categoryId, int index) async {
    state = state.copyWith(
      selectedCategory: index,
      isFoodLoading: !state.isCategoriesLoading,
    );
    if (state.allFood[index] == [] || state.allFood[index].isEmpty) {
      menuUseCase.getSelectedFood(categoryId).then((value) {
        value.fold(
          (failure) => state = state.copyWith(isFoodLoading: false),
          (food) {
            List<List<FoodEntity>> newList = List.generate(state.allFood.length,
                (each) => each == index ? food : state.allFood[each]);
            state = state.copyWith(
              isFoodLoading: false,
              allFood: newList,
              displayFood: food,
            );
          },
        );
      });
    } else {
      state = state.copyWith(
        isFoodLoading: false,
        displayFood: state.allFood[index],
      );
    }
  }

  Future getSearchedFood(String query) async {
    if (query != '') {
      state = state.copyWith(
        isSearchLoading: true,
      );
      menuUseCase.getSearchedFood(query).then((value) {
        value.fold(
          (failure) => state = state.copyWith(isSearchLoading: false),
          (food) {
            state = state.copyWith(
              isSearchLoading: false,
              searchResults: food,
            );
          },
        );
      });
    } else {
      state = state.copyWith(searchResults: []);
    }
  }

  Future getOrderedFood() => orderUseCase.getAllLocalOrders().then(
        (value) => value.fold((l) => null, (r) {
          state = state.copyWith(orders: r);
        }),
      );

  Future getFavourites() => favouritesUseCase.getFavourites().then(
        (value) => value.fold((l) => null, (r) {
          state = state.copyWith(favourites: r);
        }),
      );

  void unFocus() =>
      state = state.copyWith(isSearchFocused: false, searchResults: []);

  Future resetState() async {
    state = MenuState.initialState();
    getAllCategories();
  }
}
