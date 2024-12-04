import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/remote/http_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/constants/api_endpoints.dart';
import '../../../../../core/failure/failure.dart';

final resetRemoteDataSourceProvider =
    Provider.autoDispose<ResetRemoteDataSource>(
  (ref) => ResetRemoteDataSource(
    dio: ref.read(httpServiceProvider),
  ),
);

class ResetRemoteDataSource {
  final Dio dio;

  ResetRemoteDataSource({required this.dio});

  Future<Either<Failure, bool>> sendOTP(String number) async {
    try {
      var response = await dio.post(ApiEndpoints.sendOTP,
          data: {'phone': number, 'purpose': 'Reset'});
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

  Future<Either<Failure, bool>> resetPassword(
      String phone, String password) async {
    try {
      var response =
          await dio.put('${ApiEndpoints.resetPassword}/$phone', data: {
        'password': password,
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
