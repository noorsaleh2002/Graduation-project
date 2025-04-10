// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyARzPBtFJSvtCnWsbTFv8--hSTnyof9jmk',
    appId: '1:254718676292:web:2c322ef854098b49779b11',
    messagingSenderId: '254718676292',
    projectId: 'graduation-project-67076',
    authDomain: 'graduation-project-67076.firebaseapp.com',
    storageBucket: 'graduation-project-67076.firebasestorage.app',
    measurementId: 'G-0J7R1CZ4SE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBl7VDcCOWzQe3LLsg2nAVF9bLWqnA2Uk0',
    appId: '1:254718676292:android:b09e1f565d3dfad6779b11',
    messagingSenderId: '254718676292',
    projectId: 'graduation-project-67076',
    storageBucket: 'graduation-project-67076.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBBDL7znbbAXkT4gIHVOgq3Hh6t0PVt72Y',
    appId: '1:254718676292:ios:09420850444bb016779b11',
    messagingSenderId: '254718676292',
    projectId: 'graduation-project-67076',
    storageBucket: 'graduation-project-67076.firebasestorage.app',
    iosBundleId: 'com.example.gp2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBBDL7znbbAXkT4gIHVOgq3Hh6t0PVt72Y',
    appId: '1:254718676292:ios:09420850444bb016779b11',
    messagingSenderId: '254718676292',
    projectId: 'graduation-project-67076',
    storageBucket: 'graduation-project-67076.firebasestorage.app',
    iosBundleId: 'com.example.gp2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyARzPBtFJSvtCnWsbTFv8--hSTnyof9jmk',
    appId: '1:254718676292:web:4c5a47ff2cb7ca0a779b11',
    messagingSenderId: '254718676292',
    projectId: 'graduation-project-67076',
    authDomain: 'graduation-project-67076.firebaseapp.com',
    storageBucket: 'graduation-project-67076.firebasestorage.app',
    measurementId: 'G-SY88883TZY',
  );
}
