import 'package:flutter/material.dart';

showAlertDialogue({
  required String message,
  required BuildContext context,
  required void Function() onConfirm,
  void Function()? onCancel,
  bool barrierDismissible = true,
}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
            titlePadding: EdgeInsets.zero,
            actionsPadding: const EdgeInsets.only(bottom: 14),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            clipBehavior: Clip.hardEdge,
            shadowColor: Theme.of(context).colorScheme.tertiary,
            title: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: Text(
                'Confirmation',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontFamily: 'Blinker',
                    fontWeight: FontWeight.bold),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const SizedBox(height: 14,),
                  Text(
                    message,
                    style: const TextStyle(
                      fontFamily: 'Blinker',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: onCancel ?? () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: 'Blinker',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                  ),
                ),
              ),
              TextButton(
                onPressed: onConfirm,
                child: const Text(
                  'Proceed',
                  style: TextStyle(
                      fontFamily: 'Blinker',
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                  ),
                ),
              ),
            ]);
      });
}
