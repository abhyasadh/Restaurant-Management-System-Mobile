import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/networking/local/hive_service.dart';
import 'package:restaurant_app/features/orders/data/model/order_hive_model.dart';

import '../../../../../core/failure/failure.dart';
import '../../../domain/entity/order_entity.dart';

final orderLocalDataSourceProvider = Provider<OrderLocalDataSource>(
  (ref) => OrderLocalDataSource(
    hiveService: ref.read(hiveServiceProvider),
    orderHiveModel: ref.read(orderHiveModelProvider),
  ),
);

class OrderLocalDataSource {
  final HiveService hiveService;
  final OrderHiveModel orderHiveModel;

  OrderLocalDataSource({
    required this.hiveService,
    required this.orderHiveModel,
  });

  //Add Orders =============================================================
  Future<Either<Failure, String>> addLocalOrder(OrderEntity order) async {
    try {
      final hiveOrder = orderHiveModel.toHiveModel(order);
      final orderId = await hiveService.addLocalOrder(hiveOrder);
      return Right(orderId);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, String>> addRemoteOrder(OrderEntity order) async {
    try {
      OrderEntity newOrder = order.copyWith(entity: order, status: 'ORDERED');
      final hiveOrder = orderHiveModel.toHiveModel(newOrder);
      await hiveService.deleteAnOrder(order.orderId!);
      final orderId = await hiveService.addRemoteOrder(hiveOrder);
      return Right(orderId);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  //Get All Orders =======================================================
  Future<Either<Failure, List<OrderEntity>>> getAllLocalOrders() async {
    try {
      final hiveOrders = await hiveService.getAllLocalOrders();
      final orders = orderHiveModel.toEntityList(hiveOrders);
      return Right(orders);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<OrderEntity>>> getAllRemoteOrders() async {
    try {
      final hiveOrders = await hiveService.getAllRemoteOrders();
      final orders = orderHiveModel.toEntityList(hiveOrders);
      return Right(orders);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  //Other Local Order Queries =================================================
  Future<Either<Failure, OrderEntity>> getOrder(String key) async {
    try {
      final hiveOrder = await hiveService.getLocalOrder(key);
      final order = hiveOrder?.toEntity();
      return Right(order!);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> removeOrder(key) async {
    try {
      await hiveService.deleteAnOrder(key);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<OrderEntity>>> clearLocalOrders() async {
    try {
      final hiveOrders = await hiveService.clearLocalOrders();
      final orders = orderHiveModel.toEntityList(hiveOrders);
      return Right(orders);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<OrderEntity>>> clearRemoteOrders() async {
    try {
      final hiveOrders = await hiveService.clearRemoteOrders();
      final orders = orderHiveModel.toEntityList(hiveOrders);
      return Right(orders);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}
