import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/reset_repository.dart';

final resetUseCaseProvider = Provider.autoDispose<ResetUseCase>(
    (ref) => ResetUseCase(repository: ref.read(resetRepositoryProvider)));

class ResetUseCase {
  final IResetRepository repository;

  ResetUseCase({required this.repository});

  Future<Either<Failure, bool>> sendOTP(String number) async {
    return await repository.sendOTP(number);
  }

  Future<Either<Failure, bool>> resetPassword(
      String phone, String password) async {
    return await repository.resetPassword(phone, password);
  }
}
