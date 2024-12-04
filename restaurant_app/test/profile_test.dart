import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/features/profile/presentation/viewmodel/profile_view_model.dart';

import 'auth_test.mocks.dart';
import 'home_test.mocks.dart';

void main() {
  late ProfileViewModel profileViewModel;
  late MockUserSharedPrefs mockUserSharedPrefs;
  late MockBuildContext mockBuildContext;

  setUp(() {
    mockUserSharedPrefs = MockUserSharedPrefs();
    mockBuildContext = MockBuildContext();
    profileViewModel = ProfileViewModel(mockUserSharedPrefs);
  });

  test('logout', () async {
    when(mockUserSharedPrefs.deleteUserData()).thenAnswer((_) async => const Right(true));

    await profileViewModel.logout(mockBuildContext);

    verify(mockUserSharedPrefs.deleteUserData()).called(1);
  });

  test('checkBiometrics - can check biometrics', () async {
    const expectedCanCheckBiometrics = false;
    await profileViewModel.checkBiometrics();
    expect(profileViewModel.state.canCheckBiometrics, expectedCanCheckBiometrics);
  });
}
