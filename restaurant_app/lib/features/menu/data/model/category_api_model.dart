import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/category_entity.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryAPIModel {
  @JsonKey(name: '_id')
  final String? categoryId;
  final String categoryName;
  final String categoryImageUrl;
  final bool status;

  CategoryAPIModel(
      {this.categoryId,
      required this.categoryName,
      required this.categoryImageUrl,
      required this.status});

  factory CategoryAPIModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryAPIModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryAPIModelToJson(this);

  // From entity to model
  factory CategoryAPIModel.fromEntity(CategoryEntity entity) {
    return CategoryAPIModel(
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      categoryImageUrl: entity.categoryImageUrl,
      status: entity.status,
    );
  }

  // From model to entity
  static CategoryEntity toEntity(CategoryAPIModel model) {
    return CategoryEntity(
        categoryId: model.categoryId,
        categoryName: model.categoryName,
        categoryImageUrl: model.categoryImageUrl,
        status: model.status);
  }

  CategoryEntity toAEntity() => CategoryEntity(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryImageUrl: categoryImageUrl,
      status: status);

  CategoryAPIModel toHiveModel(CategoryEntity entity) {
    return CategoryAPIModel(
        categoryId: entity.categoryId,
        categoryName: entity.categoryName,
        categoryImageUrl: entity.categoryImageUrl,
        status: entity.status);
  }

  List<CategoryAPIModel> toHiveModelList(List<CategoryEntity> entities) =>
      entities.map((entity) => toHiveModel(entity)).toList();

  List<CategoryEntity> toEntityList(List<CategoryAPIModel> models) =>
      models.map((model) => model.toAEntity()).toList();
}
