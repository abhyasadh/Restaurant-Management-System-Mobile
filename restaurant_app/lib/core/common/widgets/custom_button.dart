import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerWidget {
  const CustomButton({super.key, required this.onPressed, required this.child});

  final Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
      onPressed: onPressed,
      child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x66ff6c44),
                spreadRadius: 8,
                blurRadius: 14,
              ),
            ],
          ),
          child: child),
    );
  }
}

class NavigatorTextButton extends StatelessWidget {
  const NavigatorTextButton(
      {super.key,
      required this.text,
      required this.buttonText,
      required this.route});

  final String text;
  final String buttonText;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Blinker',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(route);
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(1, 1)),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontFamily: 'Blinker',
                color: Color(0xff37B5DF),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
                decorationColor: Color(0xff37B5DF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
