import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/favourites/domain/repository/favourites_repository.dart';

import '../../../../core/failure/failure.dart';
import '../../../menu/domain/entity/food_entity.dart';

final favouritesUseCaseProvider = Provider<FavouritesUseCase>(
  (ref) => FavouritesUseCase(
      favouritesRepository: ref.watch(favouritesRepositoryProvider)),
);

class FavouritesUseCase {
  final IFavouritesRepository favouritesRepository;

  FavouritesUseCase({required this.favouritesRepository});

  Future<Either<Failure, List<FoodEntity>>> getFavourites() async {
    return await favouritesRepository.getFavourites();
  }

  Future<Either<Failure, bool>> editFavourites(
      {required bool add, required String foodId}) async {
    return await favouritesRepository.editFavourites(add: add, foodId: foodId);
  }
}
