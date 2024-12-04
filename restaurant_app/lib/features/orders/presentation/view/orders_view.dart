import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:restaurant_app/config/routes/app_routes.dart';
import 'package:restaurant_app/core/common/provider/get_sensor_setting.dart';
import 'package:restaurant_app/core/common/provider/get_table.dart';
import 'package:restaurant_app/features/home/home_view_model.dart';
import 'package:restaurant_app/features/orders/presentation/state/orders_state.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:action_slider/action_slider.dart';
import 'package:restaurant_app/core/common/messages/alert_dialogue.dart';
import 'package:restaurant_app/core/common/widgets/amount.dart';
import 'package:restaurant_app/core/common/widgets/order_item/order_item_view.dart';
import 'package:restaurant_app/features/orders/presentation/viewmodel/orders_view_model.dart';

import '../../../../core/common/provider/socket.dart';

class OrdersView extends ConsumerStatefulWidget {
  const OrdersView({super.key});

  @override
  ConsumerState createState() => _OrdersViewState();
}

class _OrdersViewState extends ConsumerState<OrdersView> {
  late Socket socket;

  @override
  void initState() {
    socket = ref.read(socketProvider);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSensorSubscription();
    });
  }

  void _initializeSensorSubscription() {
    final isSensorAllowed = ref.watch(getSensorSettingProvider);
    if (isSensorAllowed) {
      accelerometerEventStream().listen((AccelerometerEvent event) {
        if ((event.y.abs() > 16 || event.z.abs() > 16) &&
            !ref.read(ordersViewModelProvider).isMessageShown &&
            ref.read(ordersViewModelProvider).localOrders.isNotEmpty) {
          _clear();
        }
      });
    }
  }

  void _clear() {
    ref.read(ordersViewModelProvider.notifier).monitorAlertDialogue(true);
    showAlertDialogue(
        message: 'Are you sure you want to clear orders?',
        context: context,
        onConfirm: () {
          ref.read(ordersViewModelProvider.notifier).clearLocalOrders(ref);
          Navigator.of(context).pop();
        },
        onCancel: () {
          ref
              .read(ordersViewModelProvider.notifier)
              .monitorAlertDialogue(false);
          Navigator.of(context).pop();
        });
  }

  @override
  void dispose() {
    socket.socket.off('Cash Paid', (value) {
      ref.read(ordersViewModelProvider.notifier).clearRemoteOrders(ref);
      ref.read(getTableProvider.notifier).updateTable(null);
      ref.read(homeViewModelProvider.notifier).updateTable(null);
      ref.read(ordersViewModelProvider.notifier).resetState([]);
      Navigator.of(context)
          .popUntil((route) => route.settings.name == AppRoutes.homeRoute);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ActionSliderController();
    var orderState = ref.watch(ordersViewModelProvider);
    final socket = ref.read(socketProvider);

    return orderState.payment == Payment.notPaid
        ? Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.secondary,
              title: const Text(
                'Orders',
              ),
              centerTitle: true,
              leading: TextButton(
                onPressed: () {
                  if (orderState.localOrders.isNotEmpty) _clear();
                },
                child: const Text(
                  "Clear",
                  style: TextStyle(fontFamily: "Blinker", fontSize: 18),
                ),
              ),
              leadingWidth: 80,
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_downward_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                bottom: 70,
              ),
              child: orderState.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : orderState.localOrders.isNotEmpty ||
                          orderState.remoteOrders.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: ListView(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 72,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(25)),
                                margin:
                                    const EdgeInsets.only(bottom: 24, top: 6),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total:',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 32,
                                          fontFamily: 'Blinker',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Amount(
                                      amount: ref
                                          .read(
                                              ordersViewModelProvider.notifier)
                                          .countTotal(),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      amountFontSize: 32,
                                      currencyFontSize: 20,
                                    ),
                                  ],
                                ),
                              ),
                              orderState.remoteOrders.isNotEmpty
                                  ? _buildListWithHeading(
                                      heading: 'Ordered Items',
                                      items: List.generate(
                                        orderState.remoteOrders.length,
                                        (index) => OrderItem(
                                            order:
                                                orderState.remoteOrders[index]),
                                      ),
                                      context: context,
                                    )
                                  : const SizedBox(),
                              orderState.remoteOrders.isNotEmpty
                                  ? const SizedBox(
                                      height: 24,
                                    )
                                  : const SizedBox(),
                              orderState.localOrders.isNotEmpty
                                  ? _buildListWithHeading(
                                      heading: 'New Orders',
                                      items: List.generate(
                                          orderState.localOrders.length,
                                          (index) => OrderItem(
                                              order: orderState
                                                  .localOrders[index])),
                                      context: context)
                                  : const SizedBox(),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Nothing to show!',
                            style:
                                TextStyle(fontFamily: 'Blinker', fontSize: 20),
                          ),
                        ),
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                orderState.remoteOrders.isNotEmpty &&
                        orderState.localOrders.isEmpty
                    ? InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Theme.of(context).primaryColor,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      KhaltiScope.of(context).pay(
                                          config: PaymentConfig(
                                              amount: 10000,
                                              productIdentity: 'dummy',
                                              productName: 'dummy'),
                                          preferences: [
                                            PaymentPreference.mobileBanking
                                          ],
                                          onSuccess:
                                              (PaymentSuccessModel value) {
                                            ref
                                                .read(ordersViewModelProvider
                                                    .notifier)
                                                .checkout('PAID ONLINE');
                                            ref
                                                .read(ordersViewModelProvider
                                                    .notifier)
                                                .clearRemoteOrders(ref);
                                            ref
                                                .read(getTableProvider.notifier)
                                                .updateTable(null);
                                            ref
                                                .read(homeViewModelProvider
                                                    .notifier)
                                                .updateTable(null);
                                            ref
                                                .read(ordersViewModelProvider
                                                    .notifier)
                                                .checkout('PAID ONLINE');
                                            Navigator.of(context).popUntil(
                                                (route) =>
                                                    route.settings.name ==
                                                    AppRoutes.homeRoute);
                                          },
                                          onFailure:
                                              (PaymentFailureModel value) {},
                                          onCancel: () {});
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height:
                                          MediaQuery.of(context).size.width / 3,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Image.asset(
                                                'assets/images/mobile_banking.png'),
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Text(
                                            'Mobile Bank',
                                            style: TextStyle(
                                              fontFamily: 'Blinker',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      ref
                                          .read(
                                              ordersViewModelProvider.notifier)
                                          .checkout('CASH');
                                      socket.socket.on('Cash Paid', (value) {
                                        ref.read(ordersViewModelProvider.notifier).clearRemoteOrders(ref);
                                        ref.read(getTableProvider.notifier).updateTable(null);
                                        ref.read(homeViewModelProvider.notifier).updateTable(null);
                                        ref.read(ordersViewModelProvider.notifier).resetState([]);

                                        try{
                                          Navigator.of(context)
                                              .popUntil((route) => route.settings.name == AppRoutes.homeRoute);
                                        } catch (e) {
                                          //
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height:
                                          MediaQuery.of(context).size.width / 3,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Image.asset(
                                                'assets/images/cash.png'),
                                          ),
                                          const SizedBox(
                                            height: 14,
                                          ),
                                          Text(
                                            'Cash',
                                            style: TextStyle(
                                                fontFamily: 'Blinker',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              height: 72,
                              width: 72,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_checkout_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 36,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'Checkout',
                                    style: TextStyle(
                                        fontFamily: 'Blinker',
                                        fontSize: 11,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ],
                              )),
                        ),
                      )
                    : orderState.remoteOrders.isEmpty &&
                            orderState.localOrders.isEmpty
                        ? InkWell(
                            onTap: () {
                              socket.socket.emit('Left Without Order',
                                  ref.read(homeViewModelProvider).tableNumber);
                              ref
                                  .watch(getTableProvider.notifier)
                                  .updateTable(null);
                              ref
                                  .read(homeViewModelProvider.notifier)
                                  .updateTable(null);
                              ref
                                  .read(homeViewModelProvider.notifier)
                                  .changeIndex(2);
                              Navigator.of(context).pop();
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  height: 72,
                                  width: 72,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 36,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        'Leave',
                                        style: TextStyle(
                                            fontFamily: 'Blinker',
                                            fontSize: 11,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                    ],
                                  )),
                            ),
                          )
                        : const SizedBox(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                    ),
                    child: ActionSlider.standard(
                      controller: controller,
                      borderWidth: 6,
                      height: 72.0,
                      backgroundColor: orderState.disabled
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      icon: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Icon(
                          Icons.double_arrow_rounded,
                          color: orderState.disabled
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                          size: 40,
                        ),
                      ),
                      loadingIcon: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                        strokeWidth: 4,
                      ),
                      successIcon: Icon(
                        Icons.check_rounded,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      failureIcon: Icon(
                        Icons.close_rounded,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      customBackgroundBuilderChild: Center(
                        child: Text(
                          'Slide to Confirm!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontFamily: 'Blinker',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      customBackgroundBuilder: (context, state, child) =>
                          ClipRect(
                        child: OverflowBox(
                            maxWidth: state.standardSize.width,
                            maxHeight: state.toggleSize.height,
                            minWidth: state.standardSize.width,
                            minHeight: state.toggleSize.height,
                            child: child!),
                      ),
                      backgroundBorderRadius: BorderRadius.circular(25.0),
                      action: (controller) async {
                        if (!orderState.disabled) {
                          ref
                              .read(ordersViewModelProvider.notifier)
                              .confirmOrder(controller, ref);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.secondary,
              title: const Text(
                'Cash Confirmation',
              ),
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GifView.asset('assets/gif/scanned_loading.gif'),
                const Text("Awaiting Cash Payment...", style: TextStyle(
                  fontFamily: 'Blinker',
                  fontSize: 20
                ),),
              ],
            ),
          );
  }

  Widget _buildListWithHeading(
      {required String heading,
      required List<OrderItem> items,
      required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  height: 1.5,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                heading,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Blinker',
                    color: Theme.of(context).primaryColor),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 1.5,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return items[index];
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 12,
            );
          },
        ),
      ],
    );
  }
}
