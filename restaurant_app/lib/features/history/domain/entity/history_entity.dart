import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';

@JsonSerializable()
class HistoryEntity extends Equatable {
  final String id;
  final DateTime time;
  final List<OrderEntity> orders;
  final String payment;

  const HistoryEntity({
    required this.id,
    required this.time,
    required this.orders,
    required this.payment,
  });

  @override
  List<Object?> get props => [id, time, orders, payment];
}
