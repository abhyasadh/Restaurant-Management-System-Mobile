import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';
import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../../config/constants/hive_table_constant.dart';

part 'order_hive_model.g.dart';

final orderHiveModelProvider = Provider(
  (ref) => OrderHiveModel.empty(),
);

@HiveType(typeId: HiveTableConstant.localOrderTableId)
class OrderHiveModel {
  @HiveField(0)
  final String orderId;

  @HiveField(1)
  final Map<String, dynamic> food;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final int? status;

  // empty constructor
  OrderHiveModel.empty() : this(orderId: '', food: {}, quantity: 0, status: 0);

  OrderHiveModel({
    String? orderId,
    required this.food,
    required this.quantity,
    required this.status,
  }) : orderId = orderId ?? const Uuid().v4();

  OrderEntity toEntity() => OrderEntity(
      orderId: orderId,
      food: FoodEntity.fromJson(food),
      quantity: quantity,
      status: status == 0 ? 'UNORDERED' : 'ORDERED');

  OrderHiveModel toHiveModel(OrderEntity entity) => OrderHiveModel(
      orderId: entity.orderId,
      food: entity.food.toJson(),
      quantity: entity.quantity,
      status: entity.status == 'UNORDERED' ? 0 : 1);

  List<OrderHiveModel> toHiveModelList(List<OrderEntity> entities) =>
      entities.map((entity) => toHiveModel(entity)).toList();

  List<OrderEntity> toEntityList(List<OrderHiveModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  String toString() {
    return 'orderId: $orderId, food: $food, quantity: $quantity, status: $status';
  }
}
