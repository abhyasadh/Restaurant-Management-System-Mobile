import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/history/data/dto/history_dto.dart';
import 'package:restaurant_app/features/history/domain/entity/history_entity.dart';
import 'package:restaurant_app/features/orders/data/model/bill_api_model.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/networking/remote/http_service.dart';
import '../../../home/home_state.dart';
import '../../../home/home_view_model.dart';

final historyDataSourceProvider = Provider<HistoryDataSource>((ref) {
  return HistoryDataSource(ref.read(httpServiceProvider), ref.read(homeViewModelProvider));
});

class HistoryDataSource {
  final Dio _dio;
  final HomeState homeState;
  HistoryDataSource(this._dio, this.homeState);

  Future<Either<Failure, List<HistoryEntity>>> getPosts(int page) async {
    try {
      final response = await _dio.get(
        "${ApiEndpoints.getHistory}/${homeState.userData[2]}",
        queryParameters: {
          '_page': page,
          '_limit': ApiEndpoints.limitPage,
        },
      );
      if (response.statusCode == 200) {
        HistoryDTO historyDTO = HistoryDTO.fromJson(response.data);
        List<HistoryEntity> historyList =
        historyDTO.bills.map((bill) => BillAPIModel.toEntity(bill)).toList();
        return Right(historyList);
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(Failure(error: e.message.toString()));
    }
  }
}
