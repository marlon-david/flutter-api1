import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    //if (kIsWeb) {
    // Web
    return const FirebaseOptions(
        apiKey: "AIzaSyAIosSF51-NogCcocTCuTvKXcat3DFdsBk",
        authDomain: "marlondgoliveira.firebaseapp.com",
        databaseURL: "https://marlondgoliveira-default-rtdb.firebaseio.com",
        projectId: "marlondgoliveira",
        storageBucket: "marlondgoliveira.appspot.com",
        messagingSenderId: "307561911728",
        appId: "1:307561911728:web:11b69d7676fbb01dfc3275");
    //} else if (Platform.isIOS || Platform.isMacOS) {
    // iOS and MacOS
    //return const FirebaseOptions();
    //} else {
    // Android
    //return const FirebaseOptions();
    //}
  }
}
