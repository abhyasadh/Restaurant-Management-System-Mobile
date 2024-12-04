import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared_pref/app_prefs.dart';

final getSensorSettingProvider = StateNotifierProvider<GetSensorSetting, bool>(
  (ref) => GetSensorSetting(
    ref.watch(appPrefsProvider),
  ),
);

class GetSensorSetting extends StateNotifier<bool> {
  final AppPrefs appSensorPrefs;

  GetSensorSetting(this.appSensorPrefs) : super(false) {
    onInit();
  }

  onInit() async {
    final canUseSensor = await appSensorPrefs.getSensorUsage();
    canUseSensor.fold((l) => state = false, (r) => state = r);
  }

  updateSensorSetting(bool canUseSensor) {
    appSensorPrefs.setSensorUsage(canUseSensor);
    state = canUseSensor;
  }
}
