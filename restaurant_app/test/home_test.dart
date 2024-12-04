import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:restaurant_app/core/shared_pref/user_shared_prefs.dart';
import 'package:restaurant_app/features/home/home_view_model.dart';

import 'home_test.mocks.dart';

@GenerateMocks([UserSharedPrefs])
void main() {
  late HomeViewModel homeViewModel;
  late MockUserSharedPrefs mockUserSharedPrefs;

  setUp(() {
    mockUserSharedPrefs = MockUserSharedPrefs();
    homeViewModel = HomeViewModel(mockUserSharedPrefs);
  });

  test('updateTable', () {
    const tableNumber = '5';
    homeViewModel.updateTable(tableNumber);
    expect(homeViewModel.state.tableNumber, tableNumber);
  });

  test('changeIndex', () {
    const index = 2;
    homeViewModel.changeIndex(index);
    expect(homeViewModel.state.index, index);
  });

  test('setUserData', () {
    const userData = ['John', 'Doe'];
    homeViewModel.setUserData(userData);
    expect(homeViewModel.state.userData, userData);
  });
}
