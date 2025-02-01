import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
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
  apiKey: "AIzaSyB0bJL2ZScZXyYTmlVLBPLTOtEc-dlG-so",
  authDomain: "kodluyoruzproje-31061.firebaseapp.com",
  projectId: "kodluyoruzproje-31061",
  storageBucket: "kodluyoruzproje-31061.firebasestorage.app",
  messagingSenderId: "100544925216",
  appId: "1:100544925216:web:1b689897791b00669af645",
  measurementId: "G-SKP2LD4FYK"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: ' "AIzaSyAp7wXE-Ee9cKCNaVeSF1oB7csx9RChA7E"',
    appId:  "1:100544925216:android:7b1667d7b37949dd9af645",
    messagingSenderId: '100544925216',
    projectId: 'kodluyoruzproje-31061',
    storageBucket: "kodluyoruzproje-31061.firebasestorage.app",
  );
}
