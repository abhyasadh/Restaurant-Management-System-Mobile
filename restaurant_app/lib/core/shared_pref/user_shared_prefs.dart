import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/failure/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userSharedPrefsProvider = Provider<UserSharedPrefs>((ref) {
  return UserSharedPrefs();
});

class UserSharedPrefs {
  late SharedPreferences _sharedPreferences;

  Future<Either<Failure, bool>> setUserData(List<String> data) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setString('token', data[0]);
      await _sharedPreferences.setString('name', data[1]);
      await _sharedPreferences.setString('id', data[2]);
      await _sharedPreferences.setString('phone', data[3]);
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<String?>>> getUserData() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      final token = _sharedPreferences.getString('token');
      final name = _sharedPreferences.getString('name');
      final id = _sharedPreferences.getString('id');
      final phone = _sharedPreferences.getString('phone');
      return right([token, name, id, phone]);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> deleteUserData() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.remove('token');
      return right(true);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }
}
