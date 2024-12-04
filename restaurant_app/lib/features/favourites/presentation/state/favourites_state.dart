import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';

class FavouritesState {
  final List<FoodEntity> favourites;
  final bool isLoading;

  FavouritesState({
    required this.favourites,
    required this.isLoading,
  });

  factory FavouritesState.initial() {
    return FavouritesState(
      favourites: [],
      isLoading: false,
    );
  }

  FavouritesState copyWith({
    List<FoodEntity>? favourites,
    bool? isLoading,
  }) {
    return FavouritesState(
      favourites: favourites ?? this.favourites,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
