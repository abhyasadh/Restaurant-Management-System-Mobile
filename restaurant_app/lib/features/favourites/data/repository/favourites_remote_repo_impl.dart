import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';

import '../../domain/repository/favourites_repository.dart';
import '../data_source/favourites_remote_data_source.dart';

final favouritesRemoteRepositoryProvider =
    Provider.autoDispose<IFavouritesRepository>(
  (ref) => FavouritesRemoteRepository(
    favouritesRemoteDataSource: ref.read(favouritesRemoteDataSourceProvider),
  ),
);

class FavouritesRemoteRepository implements IFavouritesRepository {
  final FavouritesRemoteDataSource favouritesRemoteDataSource;

  const FavouritesRemoteRepository({required this.favouritesRemoteDataSource});

  @override
  Future<Either<Failure, List<FoodEntity>>> getFavourites() {
    return favouritesRemoteDataSource.getFavourites();
  }

  @override
  Future<Either<Failure, bool>> editFavourites(
      {required bool add, required String foodId}) {
    return favouritesRemoteDataSource.editFavourites(add: add, foodId: foodId);
  }
}
