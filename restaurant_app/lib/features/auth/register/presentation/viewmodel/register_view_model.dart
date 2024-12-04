import 'package:restaurant_app/config/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common/messages/snackbar.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/entity/register_entity.dart';
import '../state/register_state.dart';

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, RegisterState>(
  (ref) => RegisterViewModel(
    ref.read(registerUseCaseProvider),
  ),
);

class RegisterViewModel extends StateNotifier<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterViewModel(
    this._registerUseCase,
  ) : super(RegisterState.initialState());

  Future<void> register(RegisterEntity user, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    _registerUseCase.register(user).then((value) {
      value.fold(
        (failure) {
          try {
            showSnackBar(message: failure.error, error: true, context: context);
          } catch (e) {
            //
          }

          return state =
              state.copyWith(errors: failure.error, isLoading: false);
        },
        (success) {
          if (success) {
            try {
              state = state.copyWith(isLoading: false);
              showSnackBar(
                  message: 'Registration Successful!', context: context);
              Navigator.popAndPushNamed(context, AppRoutes.loginRoute);
            } catch (e) {
              //
            }
          }
        },
      );
    });
  }

  Future<void> sendOTP(
      String number, BuildContext context, RegisterEntity user) async {
    state = state.copyWith(isLoading: true);
    _registerUseCase.sendOTP(number).then((value) {
      value.fold(
        (failure) => state = state.copyWith(isLoading: false),
        (success) {
          if (success) {
            state = state.copyWith(isLoading: false);
            try {
              Navigator.of(context).pushNamed(AppRoutes.otpRoute, arguments: {
                'user': user,
                'nextRoute': AppRoutes.loginRoute,
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
}
