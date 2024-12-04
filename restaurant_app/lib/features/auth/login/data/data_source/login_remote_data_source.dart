import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/remote/http_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../config/constants/api_endpoints.dart';
import '../../../../../core/failure/failure.dart';

final loginRemoteDataSourceProvider =
    Provider.autoDispose<LoginRemoteDataSource>(
  (ref) => LoginRemoteDataSource(
    dio: ref.read(httpServiceProvider),
  ),
);

class LoginRemoteDataSource {
  final Dio dio;

  LoginRemoteDataSource({
    required this.dio,
  });

  Future<Either<Failure, List<String>>> login(
    String phone,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.login,
        data: {
          "phone": phone,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        if (response.data['success']) {
          String token = response.data["token"];
          String name =
              '${response.data["userData"]["firstName"]} ${response.data["userData"]["lastName"]}';
          String id = response.data["userData"]["_id"];
          String phone = response.data["userData"]["phone"];
          return Right([token, name, id, phone]);
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
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}
