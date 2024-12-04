import 'package:dartz/dartz.dart';

import 'package:restaurant_app/core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/auth/register/data/repository/register_remote_repo_impl.dart';

import '../entity/register_entity.dart';

final registerRepositoryProvider = Provider.autoDispose<IRegisterRepository>(
    (ref) => ref.read(registerRemoteRepoProvider));

abstract class IRegisterRepository {
  Future<Either<Failure, bool>> register(RegisterEntity user);
  Future<Either<Failure, bool>> sendOTP(String number);
}