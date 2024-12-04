import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/favourites/data/data_source/favourites_local_data_source.dart';
import 'package:restaurant_app/features/home/home_view_model.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/networking/remote/http_service.dart';
import '../../../home/home_state.dart';
import '../../../menu/data/dto/get_all_food_dto.dart';
import '../../../menu/data/model/food_api_model.dart';

final favouritesRemoteDataSourceProvider =
    Provider<FavouritesRemoteDataSource>((ref) {
  final dio = ref.read(httpServiceProvider);
  return FavouritesRemoteDataSource(
    dio,
    ref.read(homeViewModelProvider),
    ref.read(favouritesLocalDataSourceProvider),
  );
});

class FavouritesRemoteDataSource {
  final Dio _dio;
  final HomeState homeState;
  final FavouritesLocalDataSource localDataSource;

  FavouritesRemoteDataSource(this._dio, this.homeState, this.localDataSource);

  Future<Either<Failure, List<FoodEntity>>> getFavourites() async {
    try {
      var response = await _dio.get(
        '${ApiEndpoints.getFavourites}/${homeState.userData[2]}',
      );
      if (response.statusCode == 200) {
        GetAllFoodDTO foodDTO = GetAllFoodDTO.fromJson(response.data);
        List<FoodEntity> foodList =
            foodDTO.foods.map((food) => FoodAPIModel.toEntity(food)).toList();
        localDataSource.addFavourites(foodList);
        return Right(foodList);
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.message.toString()));
    }
  }

  Future<Either<Failure, bool>> editFavourites(
      {required bool add, required String foodId}) async {
    try {
      var response = await _dio.put(
          add
              ? '${ApiEndpoints.addToFavourites}/${homeState.userData[2]}'
              : '${ApiEndpoints.removeFromFavourites}/${homeState.userData[2]}',
          data: {'foodId': foodId});
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.message.toString()));
    }
  }
}
