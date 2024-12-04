import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/orders/data/repository/order_remote_repo_impl.dart';

import '../../../../core/failure/failure.dart';
import '../entity/order_entity.dart';

final remoteOrderRepositoryProvider = Provider<IRemoteOrderRepository>(
  (ref) => ref.read(orderRemoteRepositoryProvider),
);

abstract class IRemoteOrderRepository {
  Future<Either<Failure, bool>> addOrder(List<OrderEntity> orders);
  Future<Either<Failure, bool>> checkOut(String status);
}
