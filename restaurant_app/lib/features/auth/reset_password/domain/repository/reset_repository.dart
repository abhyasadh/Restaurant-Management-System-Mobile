import'package:dartz/dartz.dart';

import 'package:restaurant_app/core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/auth/reset_password/data/repository/reset_remote_repo_impl.dart';

final resetRepositoryProvider = Provider.autoDispose<IResetRepository>((ref) => ref.read(resetRemoteRepoProvider));

abstract class IResetRepository{
  Future<Either<Failure, bool>> sendOTP(String number);
  Future<Either<Failure, bool>> resetPassword(String phone, String password);
}