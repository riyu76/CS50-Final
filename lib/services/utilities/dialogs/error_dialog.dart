import 'package:flutter/material.dart';
import 'package:todolist/services/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDailog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An error occurred',
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
