import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/auth/otp/domain/usecases/otp_usecases.dart';
import 'package:restaurant_app/features/auth/otp/presentation/state/otp_state.dart';

import '../../../../../config/routes/app_routes.dart';

final otpViewModelProvider = StateNotifierProvider<OTPViewModel, OTPState>(
  (ref) => OTPViewModel(
    ref.read(otpUseCaseProvider),
  ),
);

class OTPViewModel extends StateNotifier<OTPState> {
  final OTPUseCase _otpUseCase;

  OTPViewModel(
    this._otpUseCase,
  ) : super(OTPState.initialState()) {
    startCountdownTimer();
  }

  Future verifyOTP (
      {required String otp,
      required BuildContext context,
      required Map<String, dynamic> args,
      Function()? addUser,
      String? number}) async {
    state = state.copyWith(isLoading: true);
    _otpUseCase.verifyOTP(otp).then((value) {
      value.fold(
        (failure) {
          return state = state.copyWith(isLoading: false);
        },
        (success) {
          state = state.copyWith(isLoading: false);
          if (args['nextRoute'] == AppRoutes.loginRoute) {
            if (success) {
              addUser!();
            }
          } else {
            try {
              Navigator.of(context).popAndPushNamed(args['nextRoute'],
                  arguments: {'phone': number});
            } catch (e){
              //
            }
          }
        },
      );
    });
  }

  void startCountdownTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timerCountDown! > 1) {
        state = state.copyWith(timerCountDown: state.timerCountDown! - 1);
      } else {
        timer.cancel();
        state = state.copyWith(isResendButtonDisabled: false);
      }
    });
  }

  void resetTimer() {
    state = state.copyWith(
      timerCountDown: 60,
      isResendButtonDisabled: true,
    );
  }
}
