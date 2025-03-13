import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:legacy_keeper/app.dart';
import 'package:legacy_keeper/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check platform and initialize Firebase accordingly
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Ensure this matches the platform
  );

  runApp(const LegacyKeeperApp());
}
