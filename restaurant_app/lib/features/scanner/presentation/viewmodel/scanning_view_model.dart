import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/scanner/presentation/state/scanner_state.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../../core/common/provider/get_table.dart';
import '../../../home/home_view_model.dart';

final scannerViewModelProvider =
StateNotifierProvider.autoDispose<ScannerViewModel, ScannerState>((ref) {
  return ScannerViewModel(
    getTable: ref.read(getTableProvider.notifier),
    homeViewModel: ref.read(homeViewModelProvider.notifier)
  );
});

class ScannerViewModel extends StateNotifier<ScannerState> {

  final GetTable getTable;
  final HomeViewModel homeViewModel;

  ScannerViewModel({required this.getTable, required this.homeViewModel}) : super(
    ScannerState.initialState(),
  );

  bool scanQR(io.Socket socket, String data){
    try {
      final jsonData = jsonDecode(data);
      if (jsonData['table']==null){
        throw Exception;
      }
      socket.emit('Request Table', jsonData['table']);
      state = state.copyWith(requested: true);
      return true;
    } catch (e){
      return false;
    }
  }

  void setTable(tableId){
    getTable.updateTable(tableId);
    homeViewModel.updateTable(tableId);
    resetState();
  }

  void resetState(){
    state = ScannerState.initialState();
  }
}
