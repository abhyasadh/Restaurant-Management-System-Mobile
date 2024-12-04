class ResetState {
  final bool isLoading;
  final String? errors;

  ResetState({required this.isLoading, this.errors});

  factory ResetState.initialState() =>
      ResetState(isLoading: false, errors: null);

  ResetState copyWith({
    bool? isLoading,
    String? errors,
    bool? showMessage,
  }) {
    return ResetState(
      isLoading: isLoading ?? this.isLoading,
      errors: errors ?? this.errors,
    );
  }
}
