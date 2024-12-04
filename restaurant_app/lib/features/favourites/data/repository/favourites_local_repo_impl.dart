import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:restaurant_app/core/failure/failure.dart';
import 'package:restaurant_app/features/favourites/data/data_source/favourites_local_data_source.dart';

import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';

import '../../domain/repository/favourites_repository.dart';

final favouritesLocalRepositoryProvider =
    Provider.autoDispose<IFavouritesRepository>(
  (ref) => FavouritesLocalRepositoryImpl(
    favouritesLocalDataSource: ref.read(favouritesLocalDataSourceProvider),
  ),
);

class FavouritesLocalRepositoryImpl implements IFavouritesRepository {
  final FavouritesLocalDataSource favouritesLocalDataSource;

  FavouritesLocalRepositoryImpl({required this.favouritesLocalDataSource});

  Future<Either<Failure, bool>> addToFavourites(List<FoodEntity> list) {
    return favouritesLocalDataSource.addFavourites(list);
  }

  @override
  Future<Either<Failure, List<FoodEntity>>> getFavourites() {
    return favouritesLocalDataSource.getAllFavourites();
  }

  @override
  Future<Either<Failure, bool>> editFavourites(
      {required bool add, required String foodId}) async {
    return Left(Failure(error: "No internet connection"));
  }
}
