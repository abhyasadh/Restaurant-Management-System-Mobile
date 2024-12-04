import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:restaurant_app/core/common/provider/get_table.dart';

import 'home_view_model.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final tableState = ref.watch(getTableProvider);

    return Scaffold(
      body: tableState != null && homeState.index == 2
          ? homeState.listWidgets[5]
          : homeState.listWidgets[homeState.index],
      bottomNavigationBar: SnakeNavigationBar.color(
        elevation: 8,
        height: 72,
        shadowColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.only(left: 14, right: 14, top: 0, bottom: 14),
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: const SnakeShape(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: EdgeInsets.all(6)),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        snakeViewColor: Theme.of(context).colorScheme.secondary,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: homeState.index,
        onTap: (index) =>
            {ref.read(homeViewModelProvider.notifier).changeIndex(index)},
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.discount_outlined,
                size: 28,
              ),
              label: 'Offers'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                size: 28,
              ),
              label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 28,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border_rounded,
                size: 28,
              ),
              label: 'Favourite'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_outlined,
                size: 28,
              ),
              label: 'Settings')
        ],
        selectedLabelStyle:
            const TextStyle(fontFamily: 'Blinker', fontSize: 11),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'Blinker', fontSize: 11),
      ),
    );
  }
}
