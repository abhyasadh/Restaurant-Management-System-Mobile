import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/remote/http_service.dart';
import 'package:restaurant_app/features/auth/register/domain/entity/register_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/constants/api_endpoints.dart';
import '../../../../../core/failure/failure.dart';
import '../model/register_api_model.dart';

final registerRemoteDataSourceProvider =
    Provider.autoDispose<RegisterRemoteDataSource>(
  (ref) => RegisterRemoteDataSource(
    dio: ref.read(httpServiceProvider),
  ),
);

class RegisterRemoteDataSource {
  final Dio dio;

  RegisterRemoteDataSource({required this.dio});

  Future<Either<Failure, bool>> register(RegisterEntity register) async {
    try {
      RegisterAPIModel registerAPIModel = RegisterAPIModel.fromEntity(register);
      var response = await dio.post(ApiEndpoints.register,
          data: registerAPIModel.toJson());
      if (response.statusCode == 200) {
        if (response.data['success']) {
          return const Right(true);
        } else {
          return Left(Failure(error: response.data["message"]));
        }
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.response?.data['message']));
    }
  }

  Future<Either<Failure, bool>> sendOTP(String number) async {
    try {
      var response = await dio.post(ApiEndpoints.sendOTP,
          data: {'phone': number, 'purpose': 'Signup'});
      if (response.statusCode == 200) {
        return const Right(true);
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
