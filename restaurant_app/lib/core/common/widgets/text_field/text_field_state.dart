import 'package:flutter/material.dart';

class TextFieldState {
  final bool isObscured;
  final Color color;

  TextFieldState({required this.isObscured, required this.color});

  factory TextFieldState.initialState() {
    return TextFieldState(isObscured: true, color: Colors.grey);
  }

  TextFieldState copyWith({
    Color? color,
    bool? isObscured,
  }) {
    return TextFieldState(
        isObscured: isObscured ?? this.isObscured, color: color ?? this.color);
  }
}
