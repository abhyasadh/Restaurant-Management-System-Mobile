import 'package:flutter/material.dart';

showSnackBar({
  required String message,
  required BuildContext context,
  bool error = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
            fontFamily: 'Blinker',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white),
      ),
      backgroundColor:
          error ? const Color(0xffe94d4d) : const Color(0xff71cc35),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      closeIconColor: Colors.white,
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: error ? Colors.red.shade700 : Colors.green, width: 3),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
