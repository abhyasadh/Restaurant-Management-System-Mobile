import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/config/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/core/common/provider/get_theme.dart';

import '../config/themes/app_theme.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(getThemeProvider);
    return KhaltiScope(
        publicKey: 'test_public_key_1c3931fa382545e69ff56ab2523fb6a2',
        builder: (context, navigatorKey) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ne', 'NP'),
            ],
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
            ],
            title: 'DishDash',
            theme: AppTheme.getApplicationTheme(isDarkTheme),
            initialRoute: AppRoutes.splashRoute,
            routes: AppRoutes.getApplicationRoute(),
            debugShowCheckedModeBanner: false,
          );
        }
    );
  }
}
