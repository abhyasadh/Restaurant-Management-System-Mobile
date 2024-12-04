import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/common/widgets/text_field/text_field_state.dart';

final textFieldViewModelProvider =
    StateNotifierProvider.family<TextFieldViewModel, TextFieldState, FocusNode>(
  (ref, node) => TextFieldViewModel(node: node),
);

class TextFieldViewModel extends StateNotifier<TextFieldState> {
  final FocusNode node;

  TextFieldViewModel({required this.node})
      : super(TextFieldState.initialState()) {
    node.addListener(() {
      if (node.hasFocus) {
        state = state.copyWith(color: const Color(0xffff6c44));
      } else {
        state = state.copyWith(color: Colors.grey);
      }
    });
  }

  void updateObscurity(bool obscure) {
    state = state.copyWith(isObscured: obscure);
  }
}
