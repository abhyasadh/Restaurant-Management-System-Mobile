import'package:dartz/dartz.dart';

import 'package:restaurant_app/core/failure/failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/auth/login/data/repository/login_remote_repo_impl.dart';

final loginRepositoryProvider = Provider.autoDispose<ILoginRepository>((ref) => ref.read(loginRemoteRepoProvider));

abstract class ILoginRepository{
  Future<Either<Failure, List<String>>> login(String phone, String password);
}