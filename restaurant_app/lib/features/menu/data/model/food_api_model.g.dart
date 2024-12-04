// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodAPIModel _$FoodAPIModelFromJson(Map<String, dynamic> json) => FoodAPIModel(
      foodId: json['_id'] as String?,
      foodName: json['foodName'] as String,
      foodImageUrl: json['foodImageUrl'] as String,
      foodPrice: (json['foodPrice'] as num).toDouble(),
      foodTime: json['foodTime'] as int,
      foodCategory: json['foodCategory'] as String,
    );

Map<String, dynamic> _$FoodAPIModelToJson(FoodAPIModel instance) =>
    <String, dynamic>{
      '_id': instance.foodId,
      'foodName': instance.foodName,
      'foodImageUrl': instance.foodImageUrl,
      'foodPrice': instance.foodPrice,
      'foodTime': instance.foodTime,
      'foodCategory': instance.foodCategory,
    };
