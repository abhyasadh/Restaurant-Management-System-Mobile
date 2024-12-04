import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/common/provider/socket.dart';
import 'package:restaurant_app/core/common/widgets/gif_controller.dart';

import 'package:restaurant_app/core/common/widgets/food_item/food_item_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gif_view/gif_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurant_app/features/home/home_view_model.dart';
import 'package:restaurant_app/features/orders/presentation/view/orders_view.dart';

import '../../../../core/common/messages/snackbar.dart';
import '../viewmodel/menu_view_model.dart';

class MenuView extends ConsumerStatefulWidget {
  const MenuView({super.key});

  @override
  ConsumerState<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends ConsumerState<MenuView> {
  TextEditingController searchController = TextEditingController();

  int selectedPage = 0;
  List<List<Widget>> menuItems = [];

  final PageController _pageController = PageController();

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        selectedPage = _pageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuViewModelProvider);
    final homeState = ref.read(homeViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              !menuState.isSearchFocused
                  ? SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Builder(
                                    builder: (BuildContext context) {
                                      final currentTime = DateTime.now();
                                      final currentHour = currentTime.hour;
                                      String greeting;
                                      if (currentHour < 12) {
                                        greeting = 'Good Morning,';
                                      } else if (currentHour < 18) {
                                        greeting = 'Good Afternoon,';
                                      } else {
                                        greeting = 'Good Evening,';
                                      }
                                      return Text(
                                        greeting,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontFamily: 'Blinker',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    menuState.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontFamily: 'Blinker',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(children: [
                                    Icon(
                                      Icons.table_restaurant_rounded,
                                      size: 12,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Table ${homeState.tableNumber}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontFamily: 'Blinker',
                                            fontSize: 11,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    )
                                  ])
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              final socket = ref.read(socketProvider);
                              socket.socket.emit('Waiter Request', homeState.tableNumber);
                              showSnackBar(
                                  message: 'A waiter will be there shortly!',
                                  context: context);
                            },
                            child: Container(
                              width: 86,
                              height: 52,
                              margin: const EdgeInsets.only(
                                  bottom: 8, right: 18, left: 14),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2)),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.front_hand_outlined, size: 26),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Request',
                                        style: TextStyle(
                                            fontSize: 9,
                                            fontFamily: 'Blinker',
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        'Waiter',
                                        style: TextStyle(
                                            fontSize: 9,
                                            fontFamily: 'Blinker',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: menuState.isSearchFocused ? 20 : 8),
                child: Row(
                  children: [
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: searchController,
                        style: const TextStyle(
                            fontFamily: 'Blinker', fontSize: 16),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: Theme.of(context).primaryColor,
                        focusNode:
                            ref.read(menuViewModelProvider.notifier).node,
                        decoration: InputDecoration(
                          hintText: 'Search for food...',
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: menuState.searchIconColor,
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 42,
                          ),
                        ),
                        onTapOutside: (e) {
                          ref
                              .read(menuViewModelProvider.notifier)
                              .node
                              .unfocus();
                          if (searchController.text.isEmpty ||
                              searchController.text == '') {
                            ref.read(menuViewModelProvider.notifier).unFocus();
                          }
                        },
                        onChanged: (value) {
                          ref
                              .read(menuViewModelProvider.notifier)
                              .getSearchedFood(value);
                        },
                      ),
                    )),
                    menuState.isSearchFocused ?
                    InkWell(
                      onTap: () {
                          searchController.text = '';
                          ref.read(menuViewModelProvider.notifier).unFocus();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.only(left: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: menuState.isSearchFocused
                            ? Icon(
                                Icons.close_rounded,
                                color: Theme.of(context).primaryColor,
                              )
                            : SvgPicture.asset('assets/svg/filter.svg'),
                      ),
                    ) : const SizedBox(),
                  ],
                ),
              ),
              // ConstrainedBox(
              //   constraints: BoxConstraints(
              //       maxWidth: min(MediaQuery
              //           .of(context)
              //           .size
              //           .width,
              //           MediaQuery
              //               .of(context)
              //               .size
              //               .height),
              //       maxHeight: min(MediaQuery
              //           .of(context)
              //           .size
              //           .width / 1.75,
              //           MediaQuery
              //               .of(context)
              //               .size
              //               .height / 1.75)),
              //   child: PageView(
              //     controller: _pageController,
              //     children: [
              //       InkWell(
              //           child: Offers(
              //             image:
              //             Image.asset(
              //               'assets/images/offer.jpg',
              //               fit: BoxFit.cover,
              //             ),
              //           )
              //       ),
              //       InkWell(
              //           child: Offers(
              //             image: GifView.asset(
              //               'assets/gif/logo_animated.gif',
              //               fit: BoxFit.cover,
              //             ),
              //           )
              //       )
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //       horizontal: MediaQuery
              //           .of(context)
              //           .size
              //           .width / 3),
              //   child: PageViewDotIndicator(
              //     currentItem: selectedPage,
              //     count: 2,
              //     unselectedColor: Colors.grey.withOpacity(0.5),
              //     selectedColor: Theme
              //         .of(context)
              //         .primaryColor,
              //     size: const Size(12, 12),
              //     unselectedSize: const Size(8, 8),
              //     duration: const Duration(milliseconds: 200),
              //     boxShape: BoxShape.circle,
              //     onItemClicked: (index) {
              //       _pageController.animateToPage(
              //         index,
              //         duration: const Duration(milliseconds: 200),
              //         curve: Curves.easeInOut,
              //       );
              //     },
              //   ),
              // ),
              const SizedBox(
                height: 12,
              ),
              !menuState.isSearchFocused
                  ? menuState.isCategoriesLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).primaryColor)
                      : SizedBox(
                          height: 100,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: menuState.categories.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  ref
                                      .read(menuViewModelProvider.notifier)
                                      .getFoodByCategory(
                                          menuState
                                              .categories[index].categoryId!,
                                          index);
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Column(
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 150),
                                      width: menuState.selectedCategory == index
                                          ? 68
                                          : 58,
                                      height:
                                          menuState.selectedCategory == index
                                              ? 68
                                              : 58,
                                      margin: EdgeInsets.symmetric(
                                        horizontal:
                                            menuState.selectedCategory == index
                                                ? 3
                                                : 8,
                                        vertical:
                                            menuState.selectedCategory == index
                                                ? 3
                                                : 8,
                                      ),
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color:
                                            menuState.selectedCategory == index
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                        borderRadius: BorderRadius.circular(
                                          menuState.selectedCategory == index
                                              ? 20
                                              : 16,
                                        ),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: menuState
                                            .categories[index].categoryImageUrl,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Transform.scale(
                                          scale: 0.5,
                                          child: CircularProgressIndicator(
                                            color: menuState.selectedCategory !=
                                                    index
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            menuState.selectedCategory == index
                                                ? 68
                                                : 58,
                                        child: Text(
                                          menuState
                                              .categories[index].categoryName,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Blinker',
                                            color: menuState.selectedCategory ==
                                                    index
                                                ? Theme.of(context).primaryColor
                                                : null,
                                            fontWeight:
                                                menuState.selectedCategory ==
                                                        index
                                                    ? FontWeight.w600
                                                    : null,
                                          ),
                                        ))
                                  ],
                                ),
                              );
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                        )
                  : const SizedBox(),
              !menuState.isSearchFocused
                  ? const SizedBox(
                      height: 16,
                    )
                  : const SizedBox(),

              !menuState.isSearchFocused
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: menuState.isFoodLoading
                          ? CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            )
                          : Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: List.generate(
                                  menuState.displayFood.length, (index) {
                                bool isOrdered = false;
                                String? orderId;
                                for (var order in menuState.orders) {
                                  if (order.food.foodId ==
                                      menuState.displayFood[index].foodId) {
                                    isOrdered = true;
                                    orderId = order.orderId;
                                    break;
                                  }
                                }
                                return FoodItem(
                                  foodItemId:
                                      menuState.displayFood[index].foodId!,
                                  name: menuState.displayFood[index].foodName,
                                  price: menuState.displayFood[index].foodPrice
                                      .roundToDouble(),
                                  image:
                                      menuState.displayFood[index].foodImageUrl,
                                  review: '4.5',
                                  timeToPrepare: '20',
                                  orderId: isOrdered ? orderId : null,
                                );
                              }),
                            ),
                    )
                  : const SizedBox(),

              menuState.isSearchLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : const SizedBox(),

              menuState.isSearchFocused &&
                      !menuState.isSearchLoading &&
                      menuState.searchResults.isEmpty &&
                      searchController.text != ''
                  ? const Center(
                      child: Text(
                        'Nothing found!',
                        style: TextStyle(fontFamily: 'Blinker', fontSize: 20),
                      ),
                    )
                  : const Center(),

              menuState.isSearchFocused &&
                      !menuState.isSearchLoading &&
                      menuState.searchResults != []
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: List.generate(menuState.searchResults.length,
                            (index) {
                          bool isOrdered = false;
                          String? orderId;
                          for (var order in menuState.orders) {
                            if (order.food.foodId ==
                                menuState.searchResults[index].foodId) {
                              isOrdered = true;
                              orderId = order.orderId;
                              break;
                            }
                          }
                          return FoodItem(
                            foodItemId: menuState.searchResults[index].foodId!,
                            name: menuState.searchResults[index].foodName,
                            price: menuState.searchResults[index].foodPrice
                                .roundToDouble(),
                            image: menuState.searchResults[index].foodImageUrl,
                            review: '4.5',
                            timeToPrepare: '20',
                            orderId: isOrdered ? orderId : null,
                          );
                        }),
                      ),
                    )
                  : const SizedBox(),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
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
                            controller:
                                ref.read(gifControllerProvider).controller,
                          )
                        : GifView.asset(
                            'assets/gif/orders-light.gif',
                            controller:
                                ref.read(gifControllerProvider).controller,
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
      ),
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

class Offers extends ConsumerWidget {
  const Offers({super.key, required this.image});

  final Widget image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              blurRadius: 14,
              spreadRadius: 4,
            ),
          ],
        ),
        margin: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: image,
        ));
  }
}
