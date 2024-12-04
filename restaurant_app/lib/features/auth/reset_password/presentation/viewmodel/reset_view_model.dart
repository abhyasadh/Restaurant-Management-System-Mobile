import 'package:restaurant_app/config/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/common/messages/snackbar.dart';

import '../../domain/usecases/reset_usecase.dart';
import '../state/reset_state.dart';

final resetViewModelProvider =
    StateNotifierProvider<ResetViewModel, ResetState>(
  (ref) => ResetViewModel(
    ref.read(resetUseCaseProvider),
  ),
);

class ResetViewModel extends StateNotifier<ResetState> {
  final ResetUseCase _resetUseCase;

  ResetViewModel(
    this._resetUseCase,
  ) : super(ResetState.initialState());

  Future<void> sendOTP(String number, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    _resetUseCase.sendOTP(number).then((value) {
      value.fold(
        (failure) => state = state.copyWith(isLoading: false),
        (success) {
          if (success) {
            state = state.copyWith(isLoading: false);
            try {
              Navigator.of(context).pushNamed(AppRoutes.otpRoute, arguments: {
                'phone': number,
                'nextRoute': AppRoutes.recoverPasswordRoute,
              });
            } catch (e){
              //
            }
          } else {
            state = state.copyWith(isLoading: false);
          }
        },
      );
    });
  }

  Future<void> updatePassword(
      String password, String number, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    _resetUseCase.resetPassword(number, password).then((value) {
      value.fold(
        (failure) => state = state.copyWith(isLoading: false),
        (success) {
          if (success) {
            state = state.copyWith(isLoading: false);
            try {
              showSnackBar(
                  message: 'Password reset successful!', context: context);
              Navigator.of(context).pushNamed(AppRoutes.loginRoute);
            } catch (e) {
              //
            }
          } else {
            state = state.copyWith(isLoading: false);
          }
        },
      );
    });
  }
}
