import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tablePrefsProvider = Provider<TablePrefs>((ref) {
  return TablePrefs();
});

class TablePrefs {
  late SharedPreferences _sharedPreferences;

  Future<Either<Failure, bool>> setTable(String number) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setString('table', number);
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, String?>> getTable() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      final table = _sharedPreferences.getString('table');
      return right(table);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> checkout() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.remove('table');
      await _sharedPreferences.remove('bill');
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> setBillId(String id) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setString('bill', id);
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<String?> getId() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      final table = _sharedPreferences.getString('bill');
      return table;
    } catch (e) {
      return null;
    }
  }
}
