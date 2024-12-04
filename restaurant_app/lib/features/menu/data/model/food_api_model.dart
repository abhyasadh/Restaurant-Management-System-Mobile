import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/food_entity.dart';

part 'food_api_model.g.dart';

@JsonSerializable()
class FoodAPIModel {
  @JsonKey(name: '_id')
  final String? foodId;
  final String foodName;
  final String foodImageUrl;
  final double foodPrice;
  final int foodTime;
  final String foodCategory;

  FoodAPIModel({
    this.foodId,
    required this.foodName,
    required this.foodImageUrl,
    required this.foodPrice,
    required this.foodTime,
    required this.foodCategory,
  });

  factory FoodAPIModel.fromJson(Map<String, dynamic> json) =>
      _$FoodAPIModelFromJson(json);

  Map<String, dynamic> toJson() => _$FoodAPIModelToJson(this);

  // From entity to model
  factory FoodAPIModel.fromEntity(FoodEntity entity) {
    return FoodAPIModel(
      foodId: entity.foodId,
      foodName: entity.foodName,
      foodImageUrl: entity.foodImageUrl,
      foodPrice: entity.foodPrice,
      foodTime: entity.foodTime,
      foodCategory: entity.foodCategory!,
    );
  }

  // From model to entity
  static FoodEntity toEntity(FoodAPIModel model) {
    return FoodEntity(
      foodId: model.foodId,
      foodName: model.foodName,
      foodImageUrl: model.foodImageUrl,
      foodPrice: model.foodPrice,
      foodTime: model.foodTime,
      foodCategory: model.foodCategory,
    );
  }

  FoodEntity toAEntity() => FoodEntity(
      foodId: foodId,
      foodName: foodName,
      foodImageUrl: foodImageUrl,
      foodPrice: foodPrice,
      foodTime: foodTime,
      foodCategory: foodCategory);

  FoodAPIModel toHiveModel(FoodEntity entity) {
    return FoodAPIModel(
      foodId: entity.foodId,
      foodName: entity.foodName,
      foodImageUrl: entity.foodImageUrl,
      foodPrice: entity.foodPrice,
      foodTime: entity.foodTime,
      foodCategory: entity.foodCategory!,
    );
  }

  List<FoodAPIModel> toHiveModelList(List<FoodEntity> entities) =>
      entities.map((entity) => toHiveModel(entity)).toList();

  List<FoodEntity> toEntityList(List<FoodAPIModel> models) =>
      models.map((model) => model.toAEntity()).toList();
}
