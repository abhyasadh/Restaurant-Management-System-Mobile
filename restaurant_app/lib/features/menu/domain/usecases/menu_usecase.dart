import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/menu/domain/entity/category_entity.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';
import 'package:restaurant_app/features/menu/domain/repository/menu_repository.dart';

import '../../../../core/failure/failure.dart';

final menuUseCaseProvider = Provider<MenuUseCase>(
  (ref) => MenuUseCase(menuRepository: ref.read(menuRepositoryProvider)),
);

class MenuUseCase {
  final IMenuRepository menuRepository;

  MenuUseCase({required this.menuRepository});

  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    return await menuRepository.getAllCategories();
  }

  Future<Either<Failure, List<FoodEntity>>> getSelectedFood(
      String categoryId) async {
    return await menuRepository.getSelectedFood(categoryId);
  }

  Future<Either<Failure, List<FoodEntity>>> getSearchedFood(
      String query) async {
    return await menuRepository.getSearchedFood(query);
  }
}
