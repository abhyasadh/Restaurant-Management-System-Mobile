// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryAPIModel _$CategoryAPIModelFromJson(Map<String, dynamic> json) =>
    CategoryAPIModel(
      categoryId: json['_id'] as String?,
      categoryName: json['categoryName'] as String,
      categoryImageUrl: json['categoryImageUrl'] as String,
      status: json['status'] as bool,
    );

Map<String, dynamic> _$CategoryAPIModelToJson(CategoryAPIModel instance) =>
    <String, dynamic>{
      '_id': instance.categoryId,
      'categoryName': instance.categoryName,
      'categoryImageUrl': instance.categoryImageUrl,
      'status': instance.status,
    };
