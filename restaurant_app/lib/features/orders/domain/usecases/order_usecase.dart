import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';
import '../../../../core/failure/failure.dart';
import '../repository/order_local_repository.dart';
import '../repository/order_remote_repository.dart';

final orderUseCaseProvider = Provider<OrderUseCase>((ref) => OrderUseCase(
      localOrderRepository: ref.read(localOrderRepositoryProvider),
      remoteOrderRepository: ref.read(remoteOrderRepositoryProvider),
    ));

class OrderUseCase {
  final ILocalOrderRepository localOrderRepository;
  final IRemoteOrderRepository remoteOrderRepository;

  OrderUseCase({
    required this.localOrderRepository,
    required this.remoteOrderRepository,
  });

  // Local Orders============================================================
  Future<Either<Failure, String>> addOrderLocally(OrderEntity order) async {
    return await localOrderRepository.addLocalOrder(order);
  }

  Future<Either<Failure, List<OrderEntity>>> getAllLocalOrders() async {
    return await localOrderRepository.getAllLocalOrders();
  }

  Future<Either<Failure, bool>> removeOrder(String key) async {
    return await localOrderRepository.deleteOrder(key);
  }

  Future<Either<Failure, List<OrderEntity>>> clearLocalOrders() async {
    return await localOrderRepository.clearLocalOrders();
  }

  Future<Either<Failure, OrderEntity>> getLocalOrder(String key) async {
    return await localOrderRepository.getOrder(key);
  }

  //Remote Orders==========================================================
  Future<Either<Failure, List<OrderEntity>>> getAllRemoteOrders() async {
    return await localOrderRepository.getAllRemoteOrders();
  }

  Future<Either<Failure, List<OrderEntity>>> clearRemoteOrders() async {
    return await localOrderRepository.clearRemoteOrders();
  }

  Future<Either<Failure, bool>> addOrder(List<OrderEntity> orders) async {
    return await remoteOrderRepository.addOrder(orders);
  }

  Future<Either<Failure, bool>> checkout(String status) async {
    return await remoteOrderRepository.checkOut(status);
  }
}
