import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable{
  final String? userId;
  final String firstName;
  final String lastName;
  final String phone;
  final String password;

  const RegisterEntity(
      {this.userId,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.password});

  @override
  List<Object?> get props => [userId, firstName, lastName, phone, password];
}
