import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? categoryId;
  final String categoryName;
  final String categoryImageUrl;
  final bool status;

  @override
  List<Object?> get props =>
      [categoryId, categoryName, categoryImageUrl, status];

  const CategoryEntity(
      {this.categoryId,
      required this.categoryName,
      required this.categoryImageUrl,
      required this.status});

  @override
  String toString() {
    return 'CategoryEntity('
        'categoryId: $categoryId, '
        'categoryName: $categoryName'
        'categoryImageUrl: $categoryImageUrl'
        'status: $status)';
  }
}
