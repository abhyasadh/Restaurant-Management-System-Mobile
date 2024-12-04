import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/shared_pref/table_prefs.dart';
import 'package:restaurant_app/features/home/home_view_model.dart';

import '../../config/routes/app_routes.dart';
import '../../core/shared_pref/user_shared_prefs.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, void>(
  (ref) {
    return SplashViewModel(ref.read(userSharedPrefsProvider),
        ref.read(tablePrefsProvider), ref.read(homeViewModelProvider.notifier));
  },
);

class SplashViewModel extends StateNotifier<void> {
  final UserSharedPrefs _userSharedPrefs;
  final TablePrefs _tablePrefs;
  final HomeViewModel _homeViewModel;

  SplashViewModel(this._userSharedPrefs, this._tablePrefs, this._homeViewModel)
      : super(null);

  init(BuildContext context) async {
    final data = await _userSharedPrefs.getUserData();
    final table = await _tablePrefs.getTable();
    data.fold((l) => null, (data) {
      if (!data.any((element) => element==null)) {
        _homeViewModel.setUserData(data);
        table.fold((l) => null, (r) {
          if (r != null) {
            _homeViewModel.updateTable(r);
          }
        });
        Navigator.popAndPushNamed(
          context,
          AppRoutes.homeRoute,
        );
      } else {
        Navigator.popAndPushNamed(
          context,
          AppRoutes.loginRoute,
        );
      }
    });
  }
}
