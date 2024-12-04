import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import 'package:restaurant_app/core/common/provider/get_table.dart';
import 'package:restaurant_app/features/menu/presentation/viewmodel/menu_view_model.dart';

import '../../../../core/common/widgets/gif_controller.dart';
import '../../../../core/common/widgets/food_item/food_item_view.dart';
import '../../../orders/presentation/view/orders_view.dart';
import '../viewmodel/favourites_view_model.dart';

class FavouritesView extends ConsumerStatefulWidget {
  const FavouritesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends ConsumerState<FavouritesView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favouritesViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Favourites',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: state.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : state.favourites.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    ref.read(favouritesViewModelProvider.notifier).resetState();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children:
                            List.generate(state.favourites.length, (index) {
                          bool isOrdered = false;
                          String? orderId;

                          for (var order
                              in ref.read(menuViewModelProvider).orders) {
                            if (order.food.foodId ==
                                state.favourites[index].foodId) {
                              isOrdered = true;
                              orderId = order.orderId;
                              break;
                            }
                          }

                          return FoodItem(
                            foodItemId: state.favourites[index].foodId!,
                            name: state.favourites[index].foodName,
                            price: state.favourites[index].foodPrice
                                .roundToDouble(),
                            image: state.favourites[index].foodImageUrl,
                            review: '4.5',
                            timeToPrepare: '20',
                            orderId: isOrdered ? orderId : null,
                          );
                        }),
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    'Nothing to show!',
                    style: TextStyle(fontFamily: 'Blinker', fontSize: 20),
                  ),
                ),
      floatingActionButton: ref.watch(getTableProvider) != null
          ? InkWell(
              onTap: () {
                Navigator.of(context).push(_createRoute());
              },
              child: Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, top: 8, bottom: 4),
                          child: Theme.of(context).colorScheme.secondary ==
                                  const Color(0xff101010)
                              ? GifView.asset(
                                  'assets/gif/orders-dark.gif',
                                  controller: ref
                                      .read(gifControllerProvider)
                                      .controller,
                                )
                              : GifView.asset(
                                  'assets/gif/orders-light.gif',
                                  controller: ref
                                      .read(gifControllerProvider)
                                      .controller,
                                )),
                      Text(
                        'Orders',
                        style: TextStyle(
                            fontFamily: 'Blinker',
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  )),
            )
          : null,
    );
  }

  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const OrdersView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
