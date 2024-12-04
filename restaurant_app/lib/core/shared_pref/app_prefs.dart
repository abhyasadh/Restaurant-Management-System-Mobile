import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../failure/failure.dart';

final appPrefsProvider = Provider((ref) {
  return AppPrefs();
});

class AppPrefs {
  late SharedPreferences _sharedPreferences;

  Future<Either<Failure, bool>> setTheme(bool value) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      _sharedPreferences.setBool('isDarkTheme', value);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> getTheme() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      final isDark = _sharedPreferences.getBool('isDarkTheme') ?? false;
      return Right(isDark);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> setSensorUsage(bool value) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      _sharedPreferences.setBool('useSensor', value);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> getSensorUsage() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      final isUsing = _sharedPreferences.getBool('useSensor') ?? false;
      return Right(isUsing);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> setBiometricUnlock(List<String> value) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      if (value[0]=='true') {
        _sharedPreferences.setStringList('useBiometric', value);
      } else {
        _sharedPreferences.remove('useBiometric');
      }
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<String>>> getBiometricUnlock() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      final isUsing = _sharedPreferences.getStringList('useBiometric');
      if (isUsing == null) {
        return Left(Failure(error: 'Error'));
      } else if (isUsing[0]=='true'){
        return Right(isUsing);
      } else {
        return Left(Failure(error: 'Error'));
      }
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}
