class ProfileState{
  bool canCheckBiometrics;

  ProfileState({
    required this.canCheckBiometrics
  });

  factory ProfileState.initialState() => ProfileState(canCheckBiometrics: false);

  ProfileState copyWith({
    bool? canCheckBiometrics,
}){
    return ProfileState(canCheckBiometrics: canCheckBiometrics?? this.canCheckBiometrics);
}
}