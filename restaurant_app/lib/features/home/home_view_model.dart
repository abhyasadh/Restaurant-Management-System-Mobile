import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/home/home_state.dart';

import '../../core/shared_pref/user_shared_prefs.dart';

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(
    ref.read(userSharedPrefsProvider),
  ),
);

class HomeViewModel extends StateNotifier<HomeState> {
  final UserSharedPrefs userSharedPrefs;

  HomeViewModel(this.userSharedPrefs) : super(HomeState.initialState());

  void updateTable(String? table) {
    state = state.copyWith(tableNumber: table);
  }

  void changeIndex(int index) {
    state = state.copyWith(index: index);
  }

  void setUserData(List<String?> data) async {
    state = state.copyWith(userData: data);
  }
}
