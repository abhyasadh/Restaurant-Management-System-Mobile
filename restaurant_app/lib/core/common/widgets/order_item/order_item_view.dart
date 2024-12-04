import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/common/widgets/amount.dart';
import 'package:restaurant_app/core/common/widgets/order_item/order_item_view_model.dart';
import 'package:restaurant_app/features/orders/domain/entity/order_entity.dart';

class OrderItem extends ConsumerWidget {
  const OrderItem({
    super.key,
    required this.order,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderItemViewModelProvider(order));

    return Visibility(
      visible: orderState.visible,
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width, minHeight: 100),
            child: Container(
              padding: const EdgeInsets.only(left: 110),
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 220,
                        child: Text(
                          order.food.foodName +
                              (orderState.ordered
                                  ? ' (×${order.quantity})'
                                  : ''),
                          style: const TextStyle(
                            fontFamily: 'Blinker',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Amount(
                        amount: order.food.foodPrice * orderState.quantity,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  !orderState.ordered
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: Container(
                            width: 60,
                            height: 26,
                            color: Theme.of(context).primaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(orderItemViewModelProvider(order)
                                            .notifier)
                                        .decrement();
                                  },
                                  child: Container(
                                      width: 18,
                                      height: 22,
                                      margin: const EdgeInsets.only(left: 2),
                                      padding: const EdgeInsets.only(left: 1),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                          left: Radius.circular(11),
                                          right: Radius.circular(4),
                                        ),
                                      ),
                                      child: const Text(
                                        '\u2212',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      )),
                                ),
                                Text(
                                  orderState.quantity.toString(),
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
                                        .read(orderItemViewModelProvider(order)
                                            .notifier)
                                        .increment();
                                  },
                                  child: Container(
                                    width: 18,
                                    height: 22,
                                    margin: const EdgeInsets.only(right: 2),
                                    padding: const EdgeInsets.only(right: 1),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        right: Radius.circular(11),
                                        left: Radius.circular(4),
                                      ),
                                    ),
                                    child: const Text(
                                      '+',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: CachedNetworkImage(
              imageUrl: order.food.foodImageUrl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Transform.scale(
                scale: 0.3,
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 10,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          !orderState.ordered
              ? Positioned(
                  top: 10,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      ref
                          .read(orderItemViewModelProvider(order).notifier)
                          .removeOrder();
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '×',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
