import 'package:equatable/equatable.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';

class OrderEntity extends Equatable {
  final String? orderId;
  final FoodEntity food;
  final int quantity;
  final String status;

  @override
  List<Object?> get props => [orderId, food, quantity, status];

  const OrderEntity({
    this.orderId,
    required this.food,
    required this.quantity,
    required this.status,
  });

  OrderEntity copyWith(
      {String? status,
      int? quantity,
      required OrderEntity entity}) {
    return OrderEntity(
        orderId: entity.orderId,
        food: entity.food,
        quantity: quantity ?? entity.quantity,
        status: status ?? entity.status);
  }

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      orderId: json['orderId'] as String?,
      food: FoodEntity.fromJson(json['foodId']),
      quantity: json['quantity'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'food': food.toJson(),
      'quantity': quantity,
      'status': status
    };
  }

  @override
  String toString() {
    return 'OrderEntity(orderId: $orderId, food: ${food.toString()}, quantity: $quantity, status: $status)';
  }
}
