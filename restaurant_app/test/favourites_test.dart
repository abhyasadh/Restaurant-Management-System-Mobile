import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:restaurant_app/features/favourites/domain/usecases/favourites_usecase.dart';
import 'package:restaurant_app/features/favourites/presentation/viewmodel/favourites_view_model.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';

import 'favourites_test.mocks.dart';

@GenerateMocks([FavouritesUseCase])
void main() {
  group('FavouritesViewModel Tests', () {
    late FavouritesViewModel favouritesViewModel;
    late MockFavouritesUseCase mockFavouritesUseCase;

    setUp(() {
      mockFavouritesUseCase = MockFavouritesUseCase();
      favouritesViewModel = FavouritesViewModel(mockFavouritesUseCase);
    });

    test('getFavourites - Success', () async {
      when(mockFavouritesUseCase.getFavourites())
          .thenAnswer((_) async => const Right([]));

      await mockFavouritesUseCase.getFavourites();

      expect(favouritesViewModel.state.isLoading, false);
      expect(favouritesViewModel.state.favourites, []);
    });

    test('getFavourites - Failure', () async {
      // Stub the getFavourites method to return a failure result
      when(mockFavouritesUseCase.getFavourites())
          .thenAnswer((_) async => Left(Failure(error: 'Failed to retrieve favourites')));

      // Execute the method under test
      await favouritesViewModel.getFavourites();

      // Assert the state after the method call
      expect(favouritesViewModel.state.isLoading, false);
      expect(favouritesViewModel.state.favourites.isEmpty, true);
    });

    test('resetState', () async {
      final favourites = <FoodEntity>[];
      when(mockFavouritesUseCase.getFavourites())
          .thenAnswer((_) async => Right(favourites));

      await favouritesViewModel.resetState();

      expect(favouritesViewModel.state.isLoading, false);
      expect(favouritesViewModel.state.favourites, favourites);
      verify(mockFavouritesUseCase.getFavourites()).called(1);
    });
  });
}