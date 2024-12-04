import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/auth/otp/domain/repository/otp_repository.dart';

final otpUseCaseProvider = Provider.autoDispose<OTPUseCase>(
    (ref) => OTPUseCase(repository: ref.read(otpRepositoryProvider)));

class OTPUseCase {
  final IOTPRepository repository;

  OTPUseCase({required this.repository});

  Future<Either<Failure, bool>> verifyOTP(String otp) async {
    return await repository.verifyOTP(otp);
  }
}
