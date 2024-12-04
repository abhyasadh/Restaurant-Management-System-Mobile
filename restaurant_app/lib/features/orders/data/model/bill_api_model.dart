import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_app/features/history/domain/entity/history_entity.dart';

import '../../domain/entity/order_entity.dart';

part 'bill_api_model.g.dart';

@JsonSerializable()
class BillAPIModel {
  @JsonKey(name: '_id')
  final String? billId;
  final String userId;
  final String tableId;
  final List<Map<String, dynamic>> orders;
  final DateTime? time;
  final String? status;
  final bool? checkout;

  BillAPIModel({
    this.billId,
    required this.userId,
    required this.tableId,
    required this.orders,
    this.time,
    this.status,
    this.checkout
  });

  factory BillAPIModel.fromJson(Map<String, dynamic> json) =>
      _$BillAPIModelFromJson(json);

  Map<String, dynamic> toJson() => _$BillAPIModelToJson(this);

  factory BillAPIModel.fromEntityList(List<OrderEntity> entity, String userId, String tableId) {
    final orders = List.generate(
      entity.length,
          (index) {
        return {
          "foodId": entity[index].food.foodId,
          "quantity": entity[index].quantity,
        };
      },
    );
    return BillAPIModel(
      userId: userId,
      tableId: tableId,
      orders: orders,
    );
  }

  static HistoryEntity toEntity(BillAPIModel model) {
    return HistoryEntity(
      id: model.billId!,
      time: model.time!,
      orders: List.generate(model.orders.length, (index) => OrderEntity.fromJson(model.orders[index])),
      payment: model.status!
    );
  }
}
