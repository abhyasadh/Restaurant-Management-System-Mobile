import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/auth/otp/domain/repository/otp_repository.dart';

import '../data_source/otp_remote_data_source.dart';

final otpRemoteRepoProvider = Provider.autoDispose<IOTPRepository>(
  (ref) => OTPRemoteRepoImpl(
    otpRemoteDataSource: ref.read(otpRemoteDataSourceProvider),
  ),
);

class OTPRemoteRepoImpl implements IOTPRepository {
  final OTPRemoteDataSource otpRemoteDataSource;

  OTPRemoteRepoImpl({required this.otpRemoteDataSource});

  @override
  Future<Either<Failure, bool>> verifyOTP(String otp) {
    return otpRemoteDataSource.verifyOTP(otp);
  }
}
