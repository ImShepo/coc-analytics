// File generated manually for Firebase project clash-of-clans-2fd27.
// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAhK6ENepppeum79cACs1Bzth9JOa6-qm8',
    appId: '1:732642728426:android:7e647cc5efeb02acf1fa93',
    messagingSenderId: '732642728426',
    projectId: 'clash-of-clans-2fd27',
    storageBucket: 'clash-of-clans-2fd27.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBtrzYvWf6iBs_dLGrMOSUgRp_5eGww31c',
    appId: '1:732642728426:ios:0c7ba12870c3730ff1fa93',
    messagingSenderId: '732642728426',
    projectId: 'clash-of-clans-2fd27',
    storageBucket: 'clash-of-clans-2fd27.appspot.com',
    iosClientId:
        '732642728426-leb04t0kgm481vfg620sev5p25ain7h8.apps.googleusercontent.com',
    iosBundleId: 'com.imshepo.coc',
  );
}
