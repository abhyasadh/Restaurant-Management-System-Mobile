// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_food_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllFoodDTO _$GetAllFoodDTOFromJson(Map<String, dynamic> json) =>
    GetAllFoodDTO(
      success: json['success'] as bool,
      foods: (json['foods'] as List<dynamic>)
          .map((e) => FoodAPIModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllFoodDTOToJson(GetAllFoodDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'foods': instance.foods,
    };
