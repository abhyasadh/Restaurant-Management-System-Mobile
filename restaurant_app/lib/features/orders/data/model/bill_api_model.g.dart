// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillAPIModel _$BillAPIModelFromJson(Map<String, dynamic> json) => BillAPIModel(
      billId: json['_id'] as String?,
      userId: json['userId'] as String,
      tableId: json['tableId'] as String,
      orders: (json['orders'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      status: json['status'] as String?,
      checkout: json['checkout'] as bool?,
    );

Map<String, dynamic> _$BillAPIModelToJson(BillAPIModel instance) =>
    <String, dynamic>{
      '_id': instance.billId,
      'userId': instance.userId,
      'tableId': instance.tableId,
      'orders': instance.orders,
      'time': instance.time?.toIso8601String(),
      'status': instance.status,
      'checkout': instance.checkout,
    };
