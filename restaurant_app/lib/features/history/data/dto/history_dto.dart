import 'package:json_annotation/json_annotation.dart';
import 'package:restaurant_app/features/orders/data/model/bill_api_model.dart';

part 'history_dto.g.dart';

@JsonSerializable()
class HistoryDTO {
  final bool success;
  final List<BillAPIModel> bills;

  HistoryDTO({required this.success, required this.bills});

  factory HistoryDTO.fromJson(Map<String, dynamic> json) =>
      _$HistoryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryDTOToJson(this);

  static HistoryDTO toEntity(HistoryDTO historyDTO) {
    return HistoryDTO(
      success: historyDTO.success,
      bills: historyDTO.bills,
    );
  }

  static HistoryDTO fromEntity(HistoryDTO getAllCourseDTO) {
    return HistoryDTO(
      success: getAllCourseDTO.success,
      bills: getAllCourseDTO.bills,
    );
  }
}
