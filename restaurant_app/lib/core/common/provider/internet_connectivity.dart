import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { notDetermined, isConnected, isDisconnected }

final connectivityStatusProvider =
    StateNotifierProvider<ConnectivityStatusNotifier, ConnectivityStatus>(
  (ref) => ConnectivityStatusNotifier(),
);

class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
  late ConnectivityStatus lastResult;

  ConnectivityStatusNotifier() : super(ConnectivityStatus.notDetermined) {
    lastResult = state;

    Connectivity().checkConnectivity().then((value) {
      _updateStatus(_convertToConnectivityStatus(value));
    });

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _updateStatus(_convertToConnectivityStatus(result));
    });
  }

  void _updateStatus(ConnectivityStatus status) {
    if (status != lastResult) {
      state = status;
      lastResult = status;
    }
  }

  ConnectivityStatus _convertToConnectivityStatus(ConnectivityResult result) {
    return result == ConnectivityResult.mobile || result == ConnectivityResult.wifi
        ? ConnectivityStatus.isConnected
        : ConnectivityStatus.isDisconnected;
  }
}

