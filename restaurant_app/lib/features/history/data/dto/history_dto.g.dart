// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryDTO _$HistoryDTOFromJson(Map<String, dynamic> json) => HistoryDTO(
      success: json['success'] as bool,
      bills: (json['bills'] as List<dynamic>)
          .map((e) => BillAPIModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HistoryDTOToJson(HistoryDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'bills': instance.bills,
    };
