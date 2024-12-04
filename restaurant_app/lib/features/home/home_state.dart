import 'package:flutter/widgets.dart';
import 'package:restaurant_app/features/history/presentation/view/history_view.dart';
import 'package:restaurant_app/features/favourites/presentation/view/favourites_view.dart';
import 'package:restaurant_app/features/menu/presentation/view/menu_view.dart';
import 'package:restaurant_app/features/offers/offers_view.dart';
import 'package:restaurant_app/features/scanner/presentation/view/scanning_view.dart';

import '../profile/presentation/view/profile_view.dart';

class HomeState {
  final int index;
  final List<Widget> listWidgets;
  final String? tableNumber;
  final List<String?> userData;

  HomeState(
      {required this.index,
      this.tableNumber,
      required this.listWidgets,
      required this.userData});

  HomeState.initialState()
      : index = 2,
        tableNumber = null,
        listWidgets = [
          const OffersView(),
          const HistoryView(),
          const ScanningView(),
          const FavouritesView(),
          const ProfileView(),
          const MenuView(),
        ],
        userData = [];

  HomeState copyWith({
    int? index,
    String? tableNumber,
    List<String?>? userData,
  }) {
    return HomeState(
        index: index ?? this.index,
        tableNumber: tableNumber ?? this.tableNumber,
        listWidgets: listWidgets,
        userData: userData ?? this.userData);
  }
}
