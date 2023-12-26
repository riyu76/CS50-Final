import 'package:flutter/material.dart';
import 'package:todolist/services/utilities/dialogs/generic_dialog.dart';

Future<void> showMessageDialog(
  BuildContext context,
  String text,
  String title,
) {
  return showGenericDialog(
    context: context,
    title: title,
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}