class LoginState {
  final bool isLoading;
  final bool biometric;
  final bool? rememberMe;
  final String? errors;

  LoginState({required this.isLoading, required this.biometric, this.rememberMe, this.errors});

  factory LoginState.initialState(bool biometric) =>
      LoginState(isLoading: false, biometric: biometric, rememberMe: false, errors: null);

  LoginState copyWith({
    bool? isLoading,
    bool? biometric,
    String? errors,
    bool? rememberMe,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      biometric: biometric ?? this.biometric,
      errors: errors ?? this.errors,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}
