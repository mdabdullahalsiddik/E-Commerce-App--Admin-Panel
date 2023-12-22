


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
   apiKey: "AIzaSyByElRTS-hO3TLh6RGvdnqTB8bxDOQYAME",
  authDomain: "ecommerce-c38c1.firebaseapp.com",
  databaseURL: "https://ecommerce-c38c1-default-rtdb.firebaseio.com",
  projectId: "ecommerce-c38c1",
  storageBucket: "ecommerce-c38c1.appspot.com",
  messagingSenderId: "18004689358",
  appId: "1:18004689358:web:57c05ac87dd4074e802b9f",
  measurementId: "G-2R3MMD7JN1"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:"AIzaSyA6uhu3-YZ2-3iLEXNtowaLHKjWeR_8zcg", // json file
    appId: "1:18004689358:android:840e386aa1484ee0802b9f",
    messagingSenderId: "18004689358",
    projectId: "ecommerce-c38c1",
    storageBucket: "ecommerce-c38c1.appspot.com",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB56-PHqeSbH0fPkcWaQoSQ54junxge0TQ',
    appId: '1:270785036491:android:7f7b6765ed4fe0b3991b4e',
    messagingSenderId: '270785036491',
    projectId: 'student-management-11713',
    storageBucket: 'student-management-11713.appspot.com',
  );
}