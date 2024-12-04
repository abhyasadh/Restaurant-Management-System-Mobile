import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:restaurant_app/features/menu/data/data_source/menu_remote_data_source.dart';
import 'package:restaurant_app/features/menu/domain/entity/category_entity.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';

import '../../domain/repository/menu_repository.dart';

final menuRemoteRepositoryProvider = Provider.autoDispose<IMenuRepository>(
  (ref) => MenuRemoteRepository(
    menuRemoteDataSource: ref.read(menuRemoteDataSourceProvider),
  ),
);

class MenuRemoteRepository implements IMenuRepository {
  final MenuRemoteDataSource menuRemoteDataSource;

  const MenuRemoteRepository({required this.menuRemoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() {
    return menuRemoteDataSource.getAllCategories();
  }

  @override
  Future<Either<Failure, List<FoodEntity>>> getSelectedFood(String categoryId) {
    return menuRemoteDataSource.getSelectedFood(categoryId);
  }

  @override
  Future<Either<Failure, List<FoodEntity>>> getSearchedFood(String query) {
    return menuRemoteDataSource.getSearchedFood(query);
  }
}
