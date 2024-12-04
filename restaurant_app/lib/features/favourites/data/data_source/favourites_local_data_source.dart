import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/networking/local/hive_service.dart';
import 'package:restaurant_app/features/favourites/data/model/favourites_hive_model.dart';

import '../../../../../core/failure/failure.dart';
import '../../../menu/domain/entity/food_entity.dart';

final favouritesLocalDataSourceProvider = Provider<FavouritesLocalDataSource>(
  (ref) => FavouritesLocalDataSource(
    hiveService: ref.read(hiveServiceProvider),
    favouriteHiveModel: ref.read(favouritesHiveModelProvider),
  ),
);

class FavouritesLocalDataSource {
  final HiveService hiveService;
  final FavouritesHiveModel favouriteHiveModel;

  FavouritesLocalDataSource({
    required this.hiveService,
    required this.favouriteHiveModel,
  });

  //Add Favourites =============================================================
  Future<Either<Failure, bool>> addFavourites(
      List<FoodEntity> favourites) async {
    try {
      final favouritesHiveList = favouriteHiveModel.toHiveModelList(favourites);
      await hiveService.addFavourites(favouritesHiveList);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  //Get All Favourites =======================================================
  Future<Either<Failure, List<FoodEntity>>> getAllFavourites() async {
    try {
      final favourites = await hiveService.getFavourites();
      final favouritesEntity = favouriteHiveModel.toEntityList(favourites);
      return Right(favouritesEntity);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}
