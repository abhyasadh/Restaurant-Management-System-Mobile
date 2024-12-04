import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/remote/http_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/menu/data/dto/get_all_category_dto.dart';
import 'package:restaurant_app/features/menu/data/dto/get_all_food_dto.dart';
import 'package:restaurant_app/features/menu/data/model/food_api_model.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../domain/entity/category_entity.dart';
import '../model/category_api_model.dart';

final menuRemoteDataSourceProvider = Provider.autoDispose<MenuRemoteDataSource>(
  (ref) => MenuRemoteDataSource(
    dio: ref.read(httpServiceProvider),
  ),
);

class MenuRemoteDataSource {
  final Dio dio;

  MenuRemoteDataSource({required this.dio});

  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      var response = await dio.get(ApiEndpoints.getAllCategory);
      if (response.statusCode == 200) {
        GetAllCategoryDTO categoryDTO =
            GetAllCategoryDTO.fromJson(response.data);
        List<CategoryEntity> categoryList = categoryDTO.categories
            .map((category) => CategoryAPIModel.toEntity(category))
            .toList();

        return Right(categoryList);
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<FoodEntity>>> getSelectedFood(
      String categoryId) async {
    try {
      var response =
          await dio.get('${ApiEndpoints.getSelectedFood}/$categoryId');
      if (response.statusCode == 200) {
        GetAllFoodDTO foodDTO = GetAllFoodDTO.fromJson(response.data);
        List<FoodEntity> foodList =
            foodDTO.foods.map((food) => FoodAPIModel.toEntity(food)).toList();

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
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<FoodEntity>>> getSearchedFood(
      String query) async {
    try {
      var response = await dio
          .get(ApiEndpoints.getSearchedFood, queryParameters: {'q': query});
      if (response.statusCode == 200) {
        GetAllFoodDTO foodDTO = GetAllFoodDTO.fromJson(response.data);
        List<FoodEntity> foodList =
            foodDTO.foods.map((food) => FoodAPIModel.toEntity(food)).toList();

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
      return Left(Failure(error: e.toString()));
    }
  }
}
