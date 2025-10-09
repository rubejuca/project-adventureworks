import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'services/product_service_firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with configuration
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Seed initial products
    final firebaseService = ProductServiceFirebase();
    await firebaseService.seedInitialProducts();
  } catch (e) {
    // If Firebase initialization fails, continue without it
    // The app will use static data as fallback
    print('Firebase initialization failed: $e');
  }

  runApp(const MyApp());
}
