import 'package:json_annotation/json_annotation.dart';

import '../model/food_api_model.dart';

part 'get_all_food_dto.g.dart';

@JsonSerializable()
class GetAllFoodDTO {
  final bool success;
  final List<FoodAPIModel> foods;

  GetAllFoodDTO({required this.success, required this.foods});

  factory GetAllFoodDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllFoodDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllFoodDTOToJson(this);

  static GetAllFoodDTO toEntity(GetAllFoodDTO getAllFoodDTO) {
    return GetAllFoodDTO(
      success: getAllFoodDTO.success,
      foods: getAllFoodDTO.foods,
    );
  }

  static GetAllFoodDTO fromEntity(GetAllFoodDTO getAllCourseDTO) {
    return GetAllFoodDTO(
      success: getAllCourseDTO.success,
      foods: getAllCourseDTO.foods,
    );
  }
}
