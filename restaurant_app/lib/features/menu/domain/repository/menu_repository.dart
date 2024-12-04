import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/menu/data/repository/menu_remote_repo_impl.dart';
import 'package:restaurant_app/features/menu/domain/entity/category_entity.dart';

import '../../../../core/failure/failure.dart';
import '../entity/food_entity.dart';

final menuRepositoryProvider = Provider.autoDispose<IMenuRepository>(
      (ref) {
      return ref.read(menuRemoteRepositoryProvider);
  },
);

abstract class IMenuRepository {
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
  Future<Either<Failure, List<FoodEntity>>> getSelectedFood(String categoryId);
  Future<Either<Failure, List<FoodEntity>>> getSearchedFood(String query);
}
