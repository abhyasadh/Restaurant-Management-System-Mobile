import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/core/common/widgets/amount.dart';
import 'package:restaurant_app/core/common/widgets/order_item/order_item_view.dart';
import 'package:restaurant_app/features/history/domain/entity/history_entity.dart';

import '../viewmodel/history_view_model.dart';

class HistoryView extends ConsumerStatefulWidget {
  const HistoryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryViewState();
}

class _HistoryViewState extends ConsumerState<HistoryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double calculateOrderTotal(HistoryEntity history) {
    double total = 0;
    for (var item in history.orders) {
      total += item.food.foodPrice * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyViewModelProvider);
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          if (_scrollController.position.extentAfter == 0) {
            ref.read(historyViewModelProvider.notifier).getHistory();
          }
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text(
            'History',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                ref.read(historyViewModelProvider.notifier).resetState();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () async {
            ref.read(historyViewModelProvider.notifier).resetState();
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 5,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(3)),
                    );
                  },
                  controller: _scrollController,
                  itemCount: state.history.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final history = state.history[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).colorScheme.secondary,
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 2)),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            DateFormat('MMMM d, yyyy (hh:mm a)')
                                .format(history.time),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                fontFamily: 'Blinker',
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          for (var order in history.orders)
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 24, left: 10, right: 10),
                              child: OrderItem(
                                order: order.copyWith(
                                  entity: order,
                                  status: 'ORDERED',
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'Payment Method: ',
                                style: TextStyle(
                                  fontFamily: 'Blinker',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 4,),
                              Text(history.payment == 'PAID ONLINE'
                                  ? 'Online'
                                  : 'Cash',
                                style: TextStyle(
                                  fontFamily: 'Blinker',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor
                                ),
                              ),
                              const SizedBox(width: 10,)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'Total: ',
                                style: TextStyle(
                                  fontFamily: 'Blinker',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(width: 8,),
                              Amount(
                                amount:
                                    calculateOrderTotal(state.history[index]),
                                color: Theme.of(context).primaryColor,
                                currencyFontSize: 16,
                                amountFontSize: 28,
                              ),
                              const SizedBox(width: 10,)
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (state.isLoading)
                const CircularProgressIndicator(color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
