import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repository/reset_repository.dart';
import '../data_source/reset_remote_data_source.dart';

final resetRemoteRepoProvider = Provider.autoDispose<IResetRepository>(
  (ref) => ResetRemoteRepoImpl(
    resetRemoteDataSource: ref.read(resetRemoteDataSourceProvider),
  ),
);

class ResetRemoteRepoImpl implements IResetRepository {
  final ResetRemoteDataSource resetRemoteDataSource;

  ResetRemoteRepoImpl({required this.resetRemoteDataSource});

  @override
  Future<Either<Failure, bool>> sendOTP(String number) {
    return resetRemoteDataSource.sendOTP(number);
  }

  @override
  Future<Either<Failure, bool>> resetPassword(String phone, String password) {
    return resetRemoteDataSource.resetPassword(phone, password);
  }
}
