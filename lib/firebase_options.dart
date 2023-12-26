// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBUeS_fB4kaAsvgIjwNZ6Siz5C_SC71CCg',
    appId: '1:605743535689:web:925cdf590564d1e01f9198',
    messagingSenderId: '605743535689',
    projectId: 'todotasks-d53af',
    authDomain: 'todotasks-d53af.firebaseapp.com',
    storageBucket: 'todotasks-d53af.appspot.com',
    measurementId: 'G-5NL0CXQ78S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCGnn5nCigcYK4mvpac7MYK6q2Ezk-e3UU',
    appId: '1:605743535689:android:07c74bfbc05da6481f9198',
    messagingSenderId: '605743535689',
    projectId: 'todotasks-d53af',
    storageBucket: 'todotasks-d53af.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpoxFlwnxqF5emcqtM40g5GWLbAqNNQCI',
    appId: '1:605743535689:ios:2807c94e9a92e82b1f9198',
    messagingSenderId: '605743535689',
    projectId: 'todotasks-d53af',
    storageBucket: 'todotasks-d53af.appspot.com',
    iosBundleId: 'eg.todotasks.todolist',
  );
}