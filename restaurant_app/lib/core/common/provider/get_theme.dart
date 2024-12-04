import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared_pref/app_prefs.dart';

final getThemeProvider = StateNotifierProvider<GetTheme, bool>(
      (ref) => GetTheme(
    ref.watch(appPrefsProvider),
  ),
);

class GetTheme extends StateNotifier<bool> {
  final AppPrefs appThemePrefs;

  GetTheme(this.appThemePrefs) : super(false) {
    onInit();
  }

  onInit() async {
    final isDarkTheme = await appThemePrefs.getTheme();
    isDarkTheme.fold(
      (l) => state = false,
      (r) => state = r
    );
  }

  updateTheme(bool isDarkTheme) {
    appThemePrefs.setTheme(isDarkTheme);
    state = isDarkTheme;
  }
}
