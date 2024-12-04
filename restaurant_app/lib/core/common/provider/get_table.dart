import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/shared_pref/table_prefs.dart';

final getTableProvider = StateNotifierProvider<GetTable, String?>(
  (ref) => GetTable(
    ref.watch(tablePrefsProvider),
  ),
);

class GetTable extends StateNotifier<String?> {
  final TablePrefs tablePrefs;

  GetTable(this.tablePrefs) : super(null) {
    onInit();
  }

  onInit() async {
    final table = await tablePrefs.getTable();
    table.fold((l) => state = null, (r) => state = r);
  }

  updateTable(String? number) {
    if (number != null) {
      tablePrefs.setTable(number);
    } else {
      tablePrefs.checkout();
    }
    state = number;
  }
}
