class OrderItemState{
  final bool isLoading;
  final int quantity;
  final bool ordered;
  final bool visible;

  OrderItemState({required this.isLoading, required this.quantity, required this.ordered, required this.visible});

  factory OrderItemState.initialState(
      {int? quantity, bool? ordered}){
    return OrderItemState(
      isLoading: false,
      quantity: quantity ?? 1,
      ordered: ordered ?? false,
      visible: true
    );
  }

  OrderItemState copyWith({
    bool? isLoading,
    int? quantity,
    bool? ordered,
    bool? visible
  }){
    return OrderItemState(
      isLoading: isLoading ?? this.isLoading,
      quantity: quantity ?? this.quantity,
      ordered: ordered ?? this.ordered,
      visible: visible ?? this.visible
    );
  }
}



