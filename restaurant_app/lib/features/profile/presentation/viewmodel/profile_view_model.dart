import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:restaurant_app/features/profile/presentation/state/profile_state.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/common/messages/snackbar.dart';
import '../../../../core/shared_pref/user_shared_prefs.dart';

final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, ProfileState>(
  (ref) => ProfileViewModel(
    ref.read(userSharedPrefsProvider),
  ),
);

class ProfileViewModel extends StateNotifier<ProfileState> {
  final UserSharedPrefs _userSharedPrefs;
  final LocalAuthentication auth = LocalAuthentication();

  ProfileViewModel(this._userSharedPrefs) : super(ProfileState.initialState()){
    checkBiometrics();
  }

  Future logout(BuildContext context) async {
    try{
      showSnackBar(message: 'Logging out...', context: context, error: true);
    } catch (e){
      //
    }

    await _userSharedPrefs.deleteUserData();
    Future.delayed(const Duration(milliseconds: 1000), () {
      try {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.loginRoute,
              (route) => false,
        );
      } catch (e){
        //
      }
    });
  }

  Future<void> checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    if (!mounted) {
      return;
    }
    state = state.copyWith(canCheckBiometrics: canCheckBiometrics);
  }
}
