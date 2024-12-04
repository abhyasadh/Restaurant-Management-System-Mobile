import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/favourites/data/repository/favourites_local_repo_impl.dart';
import 'package:restaurant_app/features/favourites/data/repository/favourites_remote_repo_impl.dart';

import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/failure/failure.dart';
import '../../../menu/domain/entity/food_entity.dart';

final favouritesRepositoryProvider =
    Provider<IFavouritesRepository>(
  (ref) {
    final internetStatus = ref.watch(connectivityStatusProvider);
    if (ConnectivityStatus.isConnected == internetStatus) {
      return ref.read(favouritesRemoteRepositoryProvider);
    } else {
      return ref.read(favouritesLocalRepositoryProvider);
    }
  },
);

abstract class IFavouritesRepository {
  Future<Either<Failure, List<FoodEntity>>> getFavourites();

  Future<Either<Failure, bool>> editFavourites(
      {required bool add, required String foodId});
}
