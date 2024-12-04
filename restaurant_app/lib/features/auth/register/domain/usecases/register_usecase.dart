import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/register_entity.dart';
import '../repository/register_repository.dart';

final registerUseCaseProvider = Provider.autoDispose<RegisterUseCase>((ref) => RegisterUseCase(repository: ref.read(registerRepositoryProvider)));

class RegisterUseCase{
  final IRegisterRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<Failure, bool>> register(RegisterEntity user) async {
    return await repository.register(user);
  }

  Future<Either<Failure, bool>> sendOTP(String number) async {
    return await repository.sendOTP(number);
  }
}