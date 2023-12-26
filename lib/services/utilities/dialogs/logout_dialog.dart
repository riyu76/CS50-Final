import 'package:flutter/material.dart';
import 'package:todolist/services/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: text,
    optionsBuilder: () => {
      'Log out' : true,
      'Cancel' : false,
    },
  // either return the above values otherwise return false 
  ).then((value) => value ?? false);
}
