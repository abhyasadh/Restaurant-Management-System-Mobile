class OTPState {
  final bool isLoading;
  final String? errors;
  final int? timerCountDown;
  final bool? isResendButtonDisabled;

  OTPState(
      {required this.isLoading,
      this.errors,
      this.timerCountDown,
      this.isResendButtonDisabled});

  factory OTPState.initialState() => OTPState(
      isLoading: false,
      errors: null,
      timerCountDown: 60,
      isResendButtonDisabled: true);

  OTPState copyWith({
    bool? isLoading,
    String? errors,
    int? timerCountDown,
    bool? isResendButtonDisabled,
  }) {
    return OTPState(
        isLoading: isLoading ?? this.isLoading,
        errors: errors ?? this.errors,
        timerCountDown: timerCountDown ?? this.timerCountDown,
        isResendButtonDisabled:
            isResendButtonDisabled ?? this.isResendButtonDisabled);
  }
}
