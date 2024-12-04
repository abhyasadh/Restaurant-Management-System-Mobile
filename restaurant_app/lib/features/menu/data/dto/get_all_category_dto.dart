import 'package:json_annotation/json_annotation.dart';

import '../model/category_api_model.dart';

part 'get_all_category_dto.g.dart';

@JsonSerializable()
class GetAllCategoryDTO {
  final bool success;
  final List<CategoryAPIModel> categories;

  GetAllCategoryDTO({required this.success, required this.categories});

  factory GetAllCategoryDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllCategoryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCategoryDTOToJson(this);

  static GetAllCategoryDTO toEntity(GetAllCategoryDTO getAllCategoryDTO) {
    return GetAllCategoryDTO(
      success: getAllCategoryDTO.success,
      categories: getAllCategoryDTO.categories,
    );
  }

  static GetAllCategoryDTO fromEntity(GetAllCategoryDTO getAllCourseDTO) {
    return GetAllCategoryDTO(
      success: getAllCourseDTO.success,
      categories: getAllCourseDTO.categories,
    );
  }
}
