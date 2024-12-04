import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';

import '../../../../config/constants/hive_table_constant.dart';

part 'favourites_hive_model.g.dart';

final favouritesHiveModelProvider = Provider(
  (ref) => FavouritesHiveModel.empty(),
);

@HiveType(typeId: HiveTableConstant.favouriteTableId)
class FavouritesHiveModel {
  @HiveField(0)
  final String foodId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final int time;

  // empty constructor
  FavouritesHiveModel.empty()
      : this(foodId: '', name: '', imageUrl: '', price: 0, time: 0);

  FavouritesHiveModel({
    required this.foodId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.time,
  });

  FoodEntity toEntity() => FoodEntity(
      foodId: foodId,
      foodName: name,
      foodImageUrl: imageUrl,
      foodPrice: price,
      foodTime: time);

  FavouritesHiveModel toHiveModel(FoodEntity entity) => FavouritesHiveModel(
      foodId: entity.foodId!,
      name: entity.foodName,
      imageUrl: entity.foodImageUrl,
      price: entity.foodPrice,
      time: entity.foodTime);

  List<FavouritesHiveModel> toHiveModelList(List<FoodEntity> entities) =>
      entities.map((entity) => toHiveModel(entity)).toList();

  List<FoodEntity> toEntityList(List<FavouritesHiveModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  String toString() {
    return 'foodId: $foodId, name: $name, image: $imageUrl, price: $price, time: $time';
  }
}
