// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllCategoryDTO _$GetAllCategoryDTOFromJson(Map<String, dynamic> json) =>
    GetAllCategoryDTO(
      success: json['success'] as bool,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryAPIModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllCategoryDTOToJson(GetAllCategoryDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'categories': instance.categories,
    };
