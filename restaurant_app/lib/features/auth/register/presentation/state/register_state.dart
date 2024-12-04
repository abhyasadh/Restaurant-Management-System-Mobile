class RegisterState {
  final bool isLoading;
  final String? errors;

  RegisterState({required this.isLoading, this.errors});

  factory RegisterState.initialState() =>
      RegisterState(isLoading: false, errors: null);

  RegisterState copyWith({
    bool? isLoading,
    String? errors,
    bool? showMessage,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errors: errors ?? this.errors,
    );
  }
}
