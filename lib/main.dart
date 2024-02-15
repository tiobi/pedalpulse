/// Flutter and Dart packages
///
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 3rd party packages
///
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pedalpulse/firebase_options.dart';
import 'package:pedalpulse/injection_container.dart';

/// App packages
///
import 'app/pedal_pulse_app.dart';

void main() async {
  /// Initialize App and Firebase
  ///
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Initialize Dependency Injection
  ///
  await initializeDependencies();

  /// Initialize Google Mobile Ads SDK
  /// Google Mobile Ads SDK does not support web.
  ///
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  runApp(const PedalPulseApp());
}
