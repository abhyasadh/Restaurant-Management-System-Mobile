import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/remote/http_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/constants/api_endpoints.dart';
import '../../../../../core/failure/failure.dart';

final otpRemoteDataSourceProvider = Provider.autoDispose<OTPRemoteDataSource>(
  (ref) => OTPRemoteDataSource(
    dio: ref.read(httpServiceProvider),
  ),
);

class OTPRemoteDataSource {
  final Dio dio;

  OTPRemoteDataSource({required this.dio});

  Future<Either<Failure, bool>> verifyOTP(String otp) async {
    try {
      var response = await dio.post(ApiEndpoints.verifyOTP, data: {
        'otp': otp,
      });
      if (response.statusCode == 200) {
        if (response.data['success']) {
          return const Right(true);
        } else {
          return const Right(false);
        }
      } else {
        return Left(Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString()));
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.response?.data['message']));
    }
  }
}
