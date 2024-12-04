import 'package:equatable/equatable.dart';

class FoodEntity extends Equatable {
  final String? foodId;
  final String foodName;
  final String foodImageUrl;
  final double foodPrice;
  final int foodTime;
  final String? foodCategory;

  @override
  List<Object?> get props =>
      [foodId, foodName, foodImageUrl, foodPrice, foodTime, foodCategory];

  const FoodEntity(
      {this.foodId,
      required this.foodName,
      required this.foodImageUrl,
      required this.foodPrice,
      required this.foodTime,
      this.foodCategory});

  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'foodImageUrl': foodImageUrl,
      'foodPrice': foodPrice,
      'foodTime': foodTime,
      'foodCategory': foodCategory
    };
  }

  factory FoodEntity.fromJson(Map<String, dynamic> json) {

      return FoodEntity(
        foodId: json['foodId'] as String?,
        foodName: json['foodName'] as String,
        foodImageUrl: json['foodImageUrl'] as String,
        foodPrice: double.parse(json['foodPrice'].toString()),
        foodTime: json['foodTime'] as int,
      );
  }

  @override
  String toString() {
    return 'FoodEntity('
        'foodId: $foodId, '
        'foodName: $foodName, '
        'foodImageUrl: $foodImageUrl, '
        'foodPrice: $foodPrice, '
        'foodTime: $foodTime, '
        'foodCategory: $foodCategory)';
  }
}
