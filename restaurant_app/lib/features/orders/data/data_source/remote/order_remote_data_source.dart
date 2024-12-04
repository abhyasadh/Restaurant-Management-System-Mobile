import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/remote/http_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/shared_pref/table_prefs.dart';
import 'package:restaurant_app/features/home/home_view_model.dart';
import 'package:restaurant_app/features/orders/data/model/bill_api_model.dart';
import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';
import 'package:restaurant_app/features/orders/domain/repository/order_local_repository.dart';

import '../../../../../config/constants/api_endpoints.dart';
import '../../../../../core/failure/failure.dart';
import '../../../../home/home_state.dart';

final orderRemoteDataSourceProvider =
    Provider.autoDispose<OrderRemoteDataSource>(
  (ref) => OrderRemoteDataSource(
      dio: ref.read(httpServiceProvider),
      homeState: ref.read(homeViewModelProvider),
      tablePrefs: ref.read(tablePrefsProvider),
      localOrderRepository: ref.read(localOrderRepositoryProvider)),
);

class OrderRemoteDataSource {
  final Dio dio;
  final HomeState homeState;
  final ILocalOrderRepository localOrderRepository;
  final TablePrefs tablePrefs;

  OrderRemoteDataSource({
    required this.dio,
    required this.homeState,
    required this.tablePrefs,
    required this.localOrderRepository,
  });

  Future<Either<Failure, bool>> order(List<OrderEntity> order) async {
    try {
      String? orderId = await tablePrefs.getId();
      String? tableId;
      await tablePrefs.getTable().then((value) => value.fold((l) => null, (r) => tableId = r));
      BillAPIModel billAPIModel = BillAPIModel.fromEntityList(
          order, homeState.userData[2]!, tableId!);
      var response = orderId == null
          ? await dio.post(ApiEndpoints.createOrders,
              data: billAPIModel.toJson())
          : await dio.put("${ApiEndpoints.addToOrders}/$orderId",
              data: billAPIModel.toJson());

      if (response.statusCode == 200) {
        if (response.data['success']) {
          if (orderId == null) await tablePrefs.setBillId(response.data['orderId']);
          for (var each in order) {
            await localOrderRepository.addRemoteOrder(each);
          }
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
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> checkOut(String status) async {
    try{
      String? orderId = await tablePrefs.getId();
      var response = await dio.put("${ApiEndpoints.updatePayment}/$orderId", data: {'status': status});
      if (response.statusCode == 200) {
        if (response.data['success']) {
          tablePrefs.checkout();
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
    } on DioException catch (e){
      return Left(Failure(error: e.toString()));
    }
  }
}
