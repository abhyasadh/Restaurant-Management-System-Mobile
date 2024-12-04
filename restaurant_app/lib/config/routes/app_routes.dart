import 'package:restaurant_app/features/home/home_view.dart';

import '../../features/auth/login/presentation/view/login_view.dart';
import '../../features/auth/reset_password/presentation/view/find_account_view.dart';
import '../../features/auth/reset_password/presentation/view/recover_password_view.dart';
import '../../features/auth/register/presentation/view/register_view.dart';
import '../../features/splash/splash_view.dart';
import '../../features/auth/otp/presentation/view/otp_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String splashRoute = '/splash';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String otpRoute = '/otp';
  static const String findAccountRoute = '/findAccount';
  static const String recoverPasswordRoute = '/recoverPassword';
  static const String homeRoute = '/home';

  static getApplicationRoute() {
    return {
      splashRoute: (context) => const SplashView(),
      loginRoute: (context) => const LoginView(),
      signupRoute: (context) => const RegisterView(),
      otpRoute: (context) => const OTPView(),
      findAccountRoute: (context) => const FindAccountView(),
      recoverPasswordRoute: (context) => const RecoverPasswordView(),
      homeRoute: (context) => const HomeView(),
    };
  }
}
