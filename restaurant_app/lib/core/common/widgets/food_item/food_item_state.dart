class FoodItemState{
  final bool isFavourite;
  final bool isOrdered;
  final String? orderId;
  final bool isLoading;
  final int quantity;

  FoodItemState({required this.isFavourite, required this.isOrdered, this.orderId, required this.isLoading, required this.quantity});

  factory FoodItemState.initialState(
      {required bool isOrdered, String? orderId, required bool isFavourite, int? quantity}){
    return FoodItemState(
      isFavourite: isFavourite,
      isOrdered: isOrdered,
      orderId: orderId,
      isLoading: false,
      quantity: quantity ?? 1
    );
  }

  FoodItemState copyWith({
    bool? isFavourite,
    bool? isOrdered,
    String? orderId,
    bool? isLoading,
    int? quantity,
  }){
    return FoodItemState(
        isFavourite: isFavourite ?? this.isFavourite,
        isOrdered: isOrdered ?? this.isOrdered,
        orderId: orderId ?? this.orderId,
        isLoading: isLoading ?? this.isLoading,
        quantity: quantity ?? this.quantity
    );
  }
}



