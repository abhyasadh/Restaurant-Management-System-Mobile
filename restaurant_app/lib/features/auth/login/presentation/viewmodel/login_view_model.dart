import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:restaurant_app/core/common/messages/snackbar.dart';
import 'package:restaurant_app/core/shared_pref/app_prefs.dart';
import 'package:restaurant_app/features/auth/login/domain/usecase/login_usecase.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/common/provider/get_biometric_setting.dart';
import '../state/login_state.dart';

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(
    ref.read(loginUseCaseProvider),
    ref.watch(getBiometricSettingProvider)
  ),
);

class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final bool _biometricUnlock;

  LoginViewModel(this._loginUseCase, this._biometricUnlock) : super(LoginState.initialState(_biometricUnlock));

  Future<void> login(
      BuildContext context, String phone, String password) async {
    state = state.copyWith(isLoading: true);
    final result = await _loginUseCase.login(phone, password);
    result.fold(
      (failure) {
        try {
          showSnackBar(message: failure.error, error: true, context: context);
        } catch (e){
          //
        }
        return state = state.copyWith(
          errors: failure.error,
        );
      },
      (success) {
        try {
          Navigator.popAndPushNamed(context, AppRoutes.homeRoute);
        } catch (e){
          //
        }
      },
    );
    state = state.copyWith(isLoading: false);
  }

  void rememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe!);
  }

  Future<String?> authenticateWithBiometrics(BuildContext context) async {
    LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan Your Fingerprint to Login!',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return null;
    }
    if (!mounted) {
      return null;
    }
    if (authenticated) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        ProviderContainer().read(appPrefsProvider).getBiometricUnlock().then(
              (value) {
                value.fold(
                      (l) => null,
                      (r) => login(context, r[1], r[2]),
                );
              }
            );
      });
    }
    return null;
  }
}
