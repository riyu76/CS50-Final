import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  // pass BuildContext as an argument when you want to show a dialog, a snack bar, or a bottom sheet
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        // .map goes through options.keys and every time it runs this function on the current element
        actions: options.keys.map((optionTitle) {
          // returns the value of the current key in "options"
          final T value = options[optionTitle];
          return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle));
        }).toList(),
      );
    },
  );
}
