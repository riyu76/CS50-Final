import 'package:flutter/material.dart' show BuildContext, ModalRoute;


// use this function to get arguments from the route
extension GetArgument on BuildContext {
  T? getArgument<T>() {
    // we are in the same route and we can get the arguments from the ModalRoute object
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}