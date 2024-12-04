import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/orders/data/repository/order_local_repo_impl.dart';

import '../../../../core/failure/failure.dart';
import '../entity/order_entity.dart';

final localOrderRepositoryProvider = Provider<ILocalOrderRepository>(
      (ref) => ref.read(orderLocalRepositoryProvider),
);

abstract class ILocalOrderRepository {
  Future<Either<Failure, String>> addLocalOrder(OrderEntity order);
  Future<Either<Failure, String>> addRemoteOrder(OrderEntity order);

  Future<Either<Failure, List<OrderEntity>>> getAllLocalOrders();
  Future<Either<Failure, List<OrderEntity>>> getAllRemoteOrders();

  Future<Either<Failure, List<OrderEntity>>> clearLocalOrders();
  Future<Either<Failure, List<OrderEntity>>> clearRemoteOrders();

  Future<Either<Failure, OrderEntity>> getOrder(String orderId);
  Future<Either<Failure, bool>> deleteOrder(String key);
}


