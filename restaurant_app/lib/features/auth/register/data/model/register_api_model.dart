import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/register_entity.dart';

@JsonSerializable()
class RegisterAPIModel {
  @JsonKey(name: '_id')
  final String? userId;
  final String firstName;
  final String lastName;
  final String phone;
  final String password;

  RegisterAPIModel(
      {this.userId,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.password});

  factory RegisterAPIModel.fromJson(Map<String, dynamic> json) {
    return RegisterAPIModel(
      userId: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'password': password,
    };
  }

  factory RegisterAPIModel.fromEntity(RegisterEntity entity) {
    return RegisterAPIModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
      password: entity.password,
    );
  }

  static RegisterEntity toEntity(RegisterAPIModel model) {
    return RegisterEntity(
        userId: model.userId,
        firstName: model.firstName,
        lastName: model.lastName,
        phone: model.phone,
        password: model.password);
  }
}
