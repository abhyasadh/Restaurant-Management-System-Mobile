import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/order_entity.dart';
import '../../domain/repository/order_local_repository.dart';
import '../data_source/local/order_local_data_source.dart';

final orderLocalRepositoryProvider = Provider<ILocalOrderRepository>(
  (ref) => OrderLocalRepositoryImpl(
    orderLocalDataSource: ref.read(orderLocalDataSourceProvider),
  ),
);

class OrderLocalRepositoryImpl implements ILocalOrderRepository {
  final OrderLocalDataSource orderLocalDataSource;

  OrderLocalRepositoryImpl({required this.orderLocalDataSource});

  @override
  Future<Either<Failure, OrderEntity>> getOrder(String orderId) {
    return orderLocalDataSource.getOrder(orderId);
  }

  @override
  Future<Either<Failure, String>> addLocalOrder(OrderEntity order) {
    return orderLocalDataSource.addLocalOrder(order);
  }

  @override
  Future<Either<Failure, String>> addRemoteOrder(OrderEntity order) {
    return orderLocalDataSource.addRemoteOrder(order);
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllLocalOrders() {
    return orderLocalDataSource.getAllLocalOrders();
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllRemoteOrders() {
    return orderLocalDataSource.getAllRemoteOrders();
  }

  @override
  Future<Either<Failure, bool>> deleteOrder(String key) {
    return orderLocalDataSource.removeOrder(key);
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> clearLocalOrders() {
    return orderLocalDataSource.clearLocalOrders();
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> clearRemoteOrders() {
    return orderLocalDataSource.clearRemoteOrders();
  }
}
