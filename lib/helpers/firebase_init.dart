import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


Future<void> initializeFirebase() async {
  // if (defaultTargetPlatform == TargetPlatform.iOS ) await Firebase.initializeApp();
  // else
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'accounts'
  );
}

// ignore_for_file: constant_identifier_names

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'FirebaseOptions not configured for web.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyChpIOZ937K4uUHipuUoxl5JBiyPmiIx_g",
    appId: '1:379065992155:android:26d5d094c1dcb2da639dfe',
    messagingSenderId: '379065992155',
    projectId: 'accounts-9b899',
    storageBucket: 'accounts-9b899.firebasestorage.app',

  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyChpIOZ937K4uUHipuUoxl5JBiyPmiIx_g",
    appId: '1:379065992155:ios:edadb67b099348f6639dfe',
    messagingSenderId: '379065992155',
    projectId: 'accounts-9b899',
    storageBucket: 'accounts-9b899.firebasestorage.app',
    iosBundleId: 'come.epulse.accounts',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyChpIOZ937K4uUHipuUoxl5JBiyPmiIx_g",
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_BUCKET.appspot.com',
    iosBundleId: 'com.example.app',
  );


  final options = FirebaseOptions(

        apiKey: "AIzaSyChpIOZ937K4uUHipuUoxl5JBiyPmiIx_g",
        authDomain: "accounts-9b899.firebaseapp.com",
        projectId: "accounts-9b899",
        storageBucket: "accounts-9b899.firebasestorage.app",
        messagingSenderId: "379065992155",
        appId: "1:379065992155:web:730f4a1b448281a3639dfe",
        measurementId: "G-N43DBW156S"

  );
}

