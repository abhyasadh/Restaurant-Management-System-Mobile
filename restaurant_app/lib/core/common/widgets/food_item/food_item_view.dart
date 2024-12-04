import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/common/provider/get_table.dart';
import 'package:restaurant_app/core/common/widgets/gif_controller.dart';
import 'package:restaurant_app/core/common/widgets/amount.dart';
import 'package:restaurant_app/core/common/widgets/food_item/food_item_view_model.dart';
import 'package:restaurant_app/features/menu/domain/entity/food_entity.dart';
import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';

class FoodItem extends ConsumerWidget {
  const FoodItem({
    super.key,
    required this.foodItemId,
    required this.image,
    required this.name,
    required this.price,
    required this.review,
    this.orderId,
    required this.timeToPrepare,
  });

  final String foodItemId;
  final String image;
  final String name;
  final double price;
  final String review;
  final String? orderId;
  final String timeToPrepare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int itemsPerRow = (MediaQuery.of(context).size.width / 175).floor();
    double width =
        175 + MediaQuery.of(context).size.width % 175 / itemsPerRow - 30;

    final foodState = ref.watch(foodItemViewModelProvider(foodItemId));

    return SizedBox(
      width: width,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.only(top: width - 120),
              constraints: const BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(80),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width - 70,
                  height: width - 70,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Transform.scale(
                      scale: 0.3,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 10,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                        width: width - 57,
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Blinker',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    InkWell(
                      onTap: () {
                        ref
                            .read(
                                foodItemViewModelProvider(foodItemId).notifier)
                            .favourite(foodItemId);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.only(right: 6, left: 3),
                        decoration: BoxDecoration(
                          color: ref.watch(getTableProvider) == null
                              ? Theme.of(context).primaryColor
                              : foodState.isFavourite
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: ref.watch(getTableProvider) == null
                              ? Theme.of(context).colorScheme.secondary
                              : foodState.isFavourite
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).primaryColor,
                          size: 14,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Amount(
                    amount: price * foodState.quantity,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                ref.watch(getTableProvider) != null
                    ? Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: AnimatedContainer(
                                width: foodState.isOrdered
                                    ? width / 2 - 60
                                    : width / 2 - 28,
                                height: 26,
                                color: Theme.of(context).primaryColor,
                                duration: const Duration(milliseconds: 200),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(foodItemViewModelProvider(
                                                    foodItemId)
                                                .notifier)
                                            .decrement();
                                      },
                                      child: AnimatedContainer(
                                          width: foodState.isOrdered ? 0 : 16,
                                          height: foodState.isOrdered ? 0 : 22,
                                          margin:
                                              const EdgeInsets.only(left: 2),
                                          padding:
                                              const EdgeInsets.only(left: 1),
                                          alignment: Alignment.center,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                              left: Radius.circular(11),
                                              right: Radius.circular(4),
                                            ),
                                          ),
                                          child: Text(
                                            foodState.isOrdered ? '' : '\u2212',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          )),
                                    ),
                                    Text(
                                      foodState.quantity.toString(),
                                      style: TextStyle(
                                          fontFamily: 'Blinker',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(foodItemViewModelProvider(
                                                    foodItemId)
                                                .notifier)
                                            .increment();
                                      },
                                      child: AnimatedContainer(
                                        width: foodState.isOrdered ? 0 : 16,
                                        height: foodState.isOrdered ? 0 : 22,
                                        margin: const EdgeInsets.only(right: 2),
                                        padding:
                                            const EdgeInsets.only(right: 1),
                                        alignment: Alignment.center,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                            right: Radius.circular(11),
                                            left: Radius.circular(4),
                                          ),
                                        ),
                                        child: Text(
                                          foodState.isOrdered ? '' : '+',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              if (foodState.isOrdered) {
                                ref
                                    .read(foodItemViewModelProvider(foodItemId)
                                        .notifier)
                                    .removeOrder(
                                        key: orderId ?? foodState.orderId!,
                                        controller: ref
                                            .read(gifControllerProvider)
                                            .controller);
                              } else {
                                ref
                                    .read(foodItemViewModelProvider(foodItemId)
                                        .notifier)
                                    .localOrder(
                                      ref
                                          .read(gifControllerProvider)
                                          .controller,
                                      OrderEntity(
                                        food: FoodEntity(
                                            foodId: foodItemId,
                                            foodName: name,
                                            foodImageUrl: image,
                                            foodPrice: price,
                                            foodTime: int.parse(timeToPrepare)),
                                        quantity: foodState.quantity,
                                        status: 'UNORDERED',
                                      ),
                                    );
                              }
                            },
                            child: AnimatedContainer(
                              width: foodState.isOrdered
                                  ? width / 2 + 38
                                  : width / 2 + 6,
                              margin: const EdgeInsets.only(left: 6),
                              height: 26,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(13)),
                              duration: const Duration(milliseconds: 200),
                              child: foodState.isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      foodState.isOrdered
                                          ? 'Remove'
                                          : 'Add to Order',
                                      style: TextStyle(
                                          fontFamily: 'Blinker',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                            ),
                          )
                        ],
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
