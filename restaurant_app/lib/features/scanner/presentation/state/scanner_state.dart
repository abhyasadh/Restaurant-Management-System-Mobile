class ScannerState {
  final bool isLoading;
  final bool requested;

  ScannerState({
    required this.isLoading,
    required this.requested
  });

  ScannerState.initialState()
      : isLoading = false, requested = false;

  ScannerState copyWith({bool? isLoading, bool? requested}) {
    return ScannerState(
      isLoading: isLoading ?? this.isLoading,
      requested: requested ?? this.requested,
    );
  }
}
