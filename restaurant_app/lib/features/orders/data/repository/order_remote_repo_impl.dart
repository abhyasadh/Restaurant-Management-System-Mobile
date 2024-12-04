import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/orders/domain/repository/order_remote_repository.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entity/order_entity.dart';
import '../data_source/remote/order_remote_data_source.dart';

final orderRemoteRepositoryProvider = Provider<IRemoteOrderRepository>(
  (ref) => OrderRemoteRepositoryImpl(
    orderRemoteDataSource: ref.read(orderRemoteDataSourceProvider),
  ),
);

class OrderRemoteRepositoryImpl implements IRemoteOrderRepository {
  final OrderRemoteDataSource orderRemoteDataSource;

  OrderRemoteRepositoryImpl({required this.orderRemoteDataSource});

  @override
  Future<Either<Failure, bool>> addOrder(List<OrderEntity> orders) {
    return orderRemoteDataSource.order(orders);
  }

  @override
  Future<Either<Failure, bool>> checkOut(String status) {
    return orderRemoteDataSource.checkOut(status);
  }
}
