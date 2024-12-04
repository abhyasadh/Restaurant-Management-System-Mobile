import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:restaurant_app/features/auth/login/domain/usecase/login_usecase.dart';
import 'package:restaurant_app/features/auth/login/presentation/viewmodel/login_view_model.dart';
import 'package:restaurant_app/features/auth/otp/domain/usecases/otp_usecases.dart';
import 'package:restaurant_app/features/auth/otp/presentation/viewmodel/otp_view_model.dart';
import 'package:restaurant_app/features/auth/register/domain/entity/register_entity.dart';
import 'package:restaurant_app/features/auth/register/domain/usecases/register_usecase.dart';
import 'package:restaurant_app/features/auth/register/presentation/viewmodel/register_view_model.dart';
import 'package:restaurant_app/features/auth/reset_password/domain/usecases/reset_usecase.dart';
import 'package:restaurant_app/features/auth/reset_password/presentation/viewmodel/reset_view_model.dart';
import 'package:restaurant_app/features/home/home_view_model.dart';

import 'auth_test.mocks.dart';

@GenerateMocks([
  LoginUseCase,
  RegisterUseCase,
  OTPUseCase,
  ResetUseCase,
  BuildContext,
  HomeViewModel,
])
void main() {

  group('LoginViewModel Tests', () {
    late LoginViewModel loginViewModel;
    late MockLoginUseCase mockLoginUseCase;
    late bool mockBiometricUnlock;
    late MockBuildContext mockBuildContext;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      mockBiometricUnlock = true;
      mockBuildContext = MockBuildContext();
      loginViewModel = LoginViewModel(mockLoginUseCase, mockBiometricUnlock);
    });

    test('login - Success', () async {
      const phone = '9860267909';
      const password = 'Adhikari1!';

      when(mockLoginUseCase.login(phone, password))
          .thenAnswer((_) async => const Right<Failure, bool>(true));

      await loginViewModel.login(mockBuildContext, phone, password);

      expect(loginViewModel.state.isLoading, false);
      verify(mockLoginUseCase.login(phone, password)).called(1);
    });

    test('login - Failure', () async {
      const phone = '9860267909';
      const password = '12345678';

      when(mockLoginUseCase.login(phone, password)).thenAnswer((_) async =>
          Left<Failure, bool>(Failure(error: "Invalid credentials")));

      await loginViewModel.login(mockBuildContext, phone, password);

      expect(loginViewModel.state.isLoading, false);
      expect(loginViewModel.state.errors, 'Invalid credentials');
      verify(mockLoginUseCase.login(phone, password)).called(1);
    });

    test('rememberMe - Toggling', () {
      final initialState = loginViewModel.state;
      loginViewModel.rememberMe();
      expect(loginViewModel.state.rememberMe, !initialState.rememberMe!);
    });

    test('authenticateWithBiometrics - Success', () async {
      await loginViewModel.authenticateWithBiometrics(mockBuildContext);
      verifyNever(mockLoginUseCase.login('9860267909', '12345678'));
    });

    test('authenticateWithBiometrics - Failure', () async {
      when(mockLoginUseCase.login('9860267909', '12345678')).thenAnswer(
          (_) async =>
              Left(Failure(error: 'Biometric authentication failed!')));
      await loginViewModel.authenticateWithBiometrics(mockBuildContext);
      verifyNever(mockLoginUseCase.login('9860267909', '12345678'));
    });
  });

  group('RegisterViewModel Tests', () {
    late RegisterViewModel registerViewModel;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockBuildContext mockBuildContext;

    setUp(() {
      mockRegisterUseCase = MockRegisterUseCase();
      mockBuildContext = MockBuildContext();
      registerViewModel = RegisterViewModel(mockRegisterUseCase);
    });

    test('register - Success', () async {
      const user = RegisterEntity(
        firstName: '',
        lastName: '',
        phone: '',
        password: '',
      );

      when(mockRegisterUseCase.register(user))
          .thenAnswer((_) async => const Right(true));

      await registerViewModel.register(user, mockBuildContext);

      expect(registerViewModel.state.isLoading, false);
      verify(mockRegisterUseCase.register(user)).called(1);
      // Add more assertions if needed
    });

    test('register - Failure', () async {
      const user = RegisterEntity(
        firstName: '',
        lastName: '',
        phone: '',
        password: '',
      );

      when(mockRegisterUseCase.register(user))
          .thenAnswer((_) async => Left(Failure(error: "Registration failed")));

      await registerViewModel.register(user, mockBuildContext);

      expect(registerViewModel.state.isLoading, false);
      expect(registerViewModel.state.errors, 'Registration failed');
      verify(mockRegisterUseCase.register(user)).called(1);
      // Add more assertions if needed
    });

    test('sendOTP - Success', () async {
      const phoneNumber = '1234567890';
      const user = RegisterEntity(
        firstName: '',
        lastName: '',
        phone: '',
        password: '',
      );

      when(mockRegisterUseCase.sendOTP(phoneNumber))
          .thenAnswer((_) async => const Right(true));

      await registerViewModel.sendOTP(phoneNumber, mockBuildContext, user);

      expect(registerViewModel.state.isLoading, false);
      verify(mockRegisterUseCase.sendOTP(phoneNumber)).called(1);
      // Add more assertions if needed
    });

    test('sendOTP - Failure', () async {
      const phoneNumber = '1234567890';
      const user = RegisterEntity(
        firstName: '',
        lastName: '',
        phone: '',
        password: '',
      );

      when(mockRegisterUseCase.sendOTP(phoneNumber))
          .thenAnswer((_) async => Left(Failure(error: "OTP sending failed!")));

      await registerViewModel.sendOTP(phoneNumber, mockBuildContext, user);

      expect(registerViewModel.state.isLoading, false);
      verify(mockRegisterUseCase.sendOTP(phoneNumber)).called(1);
      // Add more assertions if needed
    });
  });

  group('OTPViewModel Tests', () {
    late OTPViewModel otpViewModel;
    late MockOTPUseCase mockOTPUseCase;
    late MockBuildContext mockBuildContext;

    setUp(() {
      mockOTPUseCase = MockOTPUseCase();
      mockBuildContext = MockBuildContext();
      otpViewModel = OTPViewModel(mockOTPUseCase);
    });

    test('verifyOTP - Success', () async {
      const otp = '123456';
      const args = {'nextRoute': 'null'};
      when(mockOTPUseCase.verifyOTP(otp))
          .thenAnswer((_) async => const Right(true));
      otpViewModel.verifyOTP(
          otp: otp, context: mockBuildContext, args: args
      );
      expect(otpViewModel.state.isLoading, true);
      verify(mockOTPUseCase.verifyOTP(otp)).called(1);
      // Add more assertions if needed
    });

    test('verifyOTP - Failure', () async {
      const otp = '123456';
      const args = {'nextRoute': 'null'};
      when(mockOTPUseCase.verifyOTP(otp))
          .thenAnswer((_) async => Left(Failure(error: 'Invalid OTP')));

      otpViewModel.verifyOTP(
          otp: otp, context: mockBuildContext, args: args);

      expect(otpViewModel.state.isLoading, true);
      verify(mockOTPUseCase.verifyOTP(otp)).called(1);
    });

    test('startCountdownTimer', () {
      otpViewModel.startCountdownTimer();
      expect(otpViewModel.state.timerCountDown, 60);
    });

    test('resetTimer', () {
      otpViewModel.resetTimer();
      expect(otpViewModel.state.timerCountDown, 60);
      expect(otpViewModel.state.isResendButtonDisabled, true);
    });
  });

  group('ResetViewModel Tests', () {
    late ResetViewModel resetViewModel;
    late MockResetUseCase mockResetUseCase;
    late MockBuildContext mockBuildContext;

    setUp(() {
      mockResetUseCase = MockResetUseCase();
      mockBuildContext = MockBuildContext();
      resetViewModel = ResetViewModel(mockResetUseCase);
    });

    test('sendOTP - Success', () async {
      const phoneNumber = '1234567890';
      when(mockResetUseCase.sendOTP(phoneNumber))
          .thenAnswer((_) async => const Right(true));

      await resetViewModel.sendOTP(phoneNumber, mockBuildContext);

      expect(resetViewModel.state.isLoading, false);
      verify(mockResetUseCase.sendOTP(phoneNumber)).called(1);
    });

    test('sendOTP - Failure', () async {
      const phoneNumber = '1234567890';
      when(mockResetUseCase.sendOTP(phoneNumber))
          .thenAnswer((_) async => Left(Failure(error: 'Failed to send OTP')));

      await resetViewModel.sendOTP(phoneNumber, mockBuildContext);

      expect(resetViewModel.state.isLoading, false);
      verify(mockResetUseCase.sendOTP(phoneNumber)).called(1);
    });

    test('updatePassword - Success', () async {
      const phoneNumber = '1234567890';
      const password = 'NewPassword';
      when(mockResetUseCase.resetPassword(phoneNumber, password))
          .thenAnswer((_) async => const Right(true));

      await resetViewModel.updatePassword(password, phoneNumber, mockBuildContext);

      expect(resetViewModel.state.isLoading, false);
      verify(mockResetUseCase.resetPassword(phoneNumber, password)).called(1);
    });

    test('updatePassword - Failure', () async {
      const phoneNumber = '1234567890';
      const password = 'NewPassword';
      when(mockResetUseCase.resetPassword(phoneNumber, password))
          .thenAnswer((_) async => Left(Failure(error: 'Failed to reset password')));

      await resetViewModel.updatePassword(password, phoneNumber, mockBuildContext);

      expect(resetViewModel.state.isLoading, false);
      verify(mockResetUseCase.resetPassword(phoneNumber, password)).called(1);
    });
  });

}
