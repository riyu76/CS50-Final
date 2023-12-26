import 'package:flutter/material.dart';
import 'package:todolist/services/utilities/dialogs/generic_dialog.dart';

Future<bool?> showDeleteDialog(BuildContext context, String text) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete Task",
    content: text,
    optionsBuilder: () => {
      'Cancel' : false,
      'Delete' : true,
    },
  ).then((value) => value ?? false);
}
