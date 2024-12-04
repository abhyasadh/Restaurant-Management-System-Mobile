import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/failure/failure.dart';
import '../../data/repository/otp_remote_repo_impl.dart';

final otpRepositoryProvider = Provider.autoDispose<IOTPRepository>(
    (ref) => ref.read(otpRemoteRepoProvider));

abstract class IOTPRepository {
  Future<Either<Failure, bool>> verifyOTP(String otp);
}
