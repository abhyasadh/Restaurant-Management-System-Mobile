import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/features/home/home_view_model.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../../core/shared_pref/user_shared_prefs.dart';
import '../repository/login_repository.dart';

final loginUseCaseProvider = Provider.autoDispose<LoginUseCase>(
  (ref) => LoginUseCase(
    loginRepository: ref.watch(loginRepositoryProvider),
    userSharedPrefs: ref.watch(userSharedPrefsProvider),
    homeViewModel: ref.read(homeViewModelProvider.notifier),
  ),
);

class LoginUseCase {
  final ILoginRepository loginRepository;
  final UserSharedPrefs userSharedPrefs;
  final HomeViewModel homeViewModel;

  LoginUseCase({
    required this.loginRepository,
    required this.userSharedPrefs,
    required this.homeViewModel,
  });

  Future<Either<Failure, bool>> login(String phone, String password) async {
    final result = await loginRepository.login(phone, password);
    return result.fold(
      (failure) => Left(failure),
      (success) async {
        await userSharedPrefs.setUserData(success);
        homeViewModel.setUserData(success);
        return const Right(true);
      },
    );
  }
}
