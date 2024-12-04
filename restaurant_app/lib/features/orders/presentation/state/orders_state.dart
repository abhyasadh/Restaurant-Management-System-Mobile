import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';

enum Payment { notPaid, requested }

class OrdersState {
  bool isLoading;
  bool isMessageShown;
  List<OrderEntity> localOrders;
  List<OrderEntity> remoteOrders;
  Payment payment;
  bool disabled;

  OrdersState(
      {required this.isLoading,
      required this.isMessageShown,
      required this.disabled,
      required this.localOrders,
      required this.remoteOrders,
      required this.payment
      });

  factory OrdersState.initialState(
          List<OrderEntity> unordered, List<OrderEntity> ordered) =>
      OrdersState(
        isLoading: false,
        isMessageShown: false,
        disabled: unordered.isEmpty || unordered == [],
        localOrders: unordered,
        remoteOrders: ordered,
        payment: Payment.notPaid
      );

  OrdersState copyWith({
    bool? isLoading,
    bool? isMessageShown,
    bool? disabled,
    List<OrderEntity>? localOrders,
    List<OrderEntity>? remoteOrders,
    Payment? payment,
  }) {
    return OrdersState(
      isLoading: isLoading ?? this.isLoading,
      isMessageShown: isMessageShown ?? this.isMessageShown,
      disabled: disabled ?? this.disabled,
      localOrders: localOrders ?? this.localOrders,
      remoteOrders: remoteOrders ?? this.remoteOrders,
      payment: payment ?? this.payment
    );
  }
}
