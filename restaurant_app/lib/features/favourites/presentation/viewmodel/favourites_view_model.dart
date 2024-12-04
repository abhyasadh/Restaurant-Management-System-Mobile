import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/favourites/domain/usecases/favourites_usecase.dart';

import '../state/favourites_state.dart';

final favouritesViewModelProvider =
    StateNotifierProvider.autoDispose<FavouritesViewModel, FavouritesState>(
        (ref) {
  return FavouritesViewModel(
    ref.watch(favouritesUseCaseProvider),
  );
});

class FavouritesViewModel extends StateNotifier<FavouritesState> {
  final FavouritesUseCase _favouritesUseCase;

  FavouritesViewModel(this._favouritesUseCase)
      : super(
          FavouritesState.initial(),
        ) {
    getFavourites();
  }

  Future getFavourites() async {
    state = state.copyWith(isLoading: true);
    final result = await _favouritesUseCase.getFavourites();
    result.fold((failure) => state = state.copyWith(isLoading: false), (data) {
      state = state.copyWith(
        favourites: data,
        isLoading: false,
      );
    });
  }

  Future resetState() async {
    state = FavouritesState.initial();
    getFavourites();
  }
}
