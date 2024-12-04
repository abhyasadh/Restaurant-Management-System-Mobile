import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/core/common/widgets/text_field/text_field_view_model.dart';

class CustomTextField extends ConsumerStatefulWidget {
  const CustomTextField(
      {super.key,
      required this.label,
      required this.hintText,
      required this.icon,
      required this.controller,
      required this.node,
      required this.validator,
      this.keyBoardType,
      this.obscureText});

  final String label;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode node;
  final String? Function(String?) validator;
  final TextInputType? keyBoardType;
  final bool? obscureText;

  @override
  ConsumerState<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ConsumerState<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final textFieldState = ref.watch(textFieldViewModelProvider(widget.node));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != ''
            ? Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
            : const SizedBox(),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            controller: widget.controller,
            style: const TextStyle(fontFamily: 'Blinker', fontSize: 16),
            keyboardType: widget.keyBoardType ?? TextInputType.text,
            textCapitalization: textFieldState.isObscured
                ? TextCapitalization.none
                : TextCapitalization.words,
            cursorColor: Theme.of(context).primaryColor,
            obscureText:
                widget.obscureText != null && widget.obscureText == true
                    ? textFieldState.isObscured
                    : false,
            obscuringCharacter: '●',
            validator: widget.validator,
            focusNode: widget.node,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: Icon(
                widget.icon,
                size: 20,
                color: textFieldState.color,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 42,
              ),
              suffixIcon:
                  widget.obscureText != null && widget.obscureText == true
                      ? IconButton(
                          icon: Icon(
                            textFieldState.isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                            color: textFieldState.color,
                          ),
                          splashRadius: 1,
                          onPressed: () {
                            ref
                                .read(textFieldViewModelProvider(widget.node)
                                    .notifier)
                                .updateObscurity(!textFieldState.isObscured);
                          },
                        )
                      : null,
              errorStyle:
                  TextStyle(fontFamily: 'Blinker', color: Colors.red.shade800),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.shade800,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(
                    10.0), // You can also define border radius.
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.shade800,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onTapOutside: (e) {
              widget.node.unfocus();
            },
          ),
        )
      ],
    );
  }
}
