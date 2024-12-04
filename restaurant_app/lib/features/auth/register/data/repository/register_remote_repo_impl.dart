import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/register_entity.dart';
import '../../domain/repository/register_repository.dart';
import '../data_source/register_remote_data_source.dart';

final registerRemoteRepoProvider = Provider.autoDispose<IRegisterRepository>(
  (ref) => RegisterRemoteRepoImpl(
    registerRemoteDataSource: ref.read(registerRemoteDataSourceProvider),
  ),
);

class RegisterRemoteRepoImpl implements IRegisterRepository {
  final RegisterRemoteDataSource registerRemoteDataSource;

  RegisterRemoteRepoImpl({required this.registerRemoteDataSource});

  @override
  Future<Either<Failure, bool>> register(RegisterEntity user) {
    return registerRemoteDataSource.register(user);
  }

  @override
  Future<Either<Failure, bool>> sendOTP(String number) {
    return registerRemoteDataSource.sendOTP(number);
  }
}
