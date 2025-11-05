import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'services/product_service_firebase.dart';
import 'services/product_service_static.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool useFirebase = true;

  try {
    // Initialize Firebase with configuration
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Seed initial products
    final firebaseService = ProductServiceFirebase();
    await firebaseService.seedInitialProducts();
  } on FirebaseException catch (e) {
    // Specific handling for Firebase exceptions
    print('Firebase error: ${e.message}');
    print('Error code: ${e.code}');
    useFirebase = false;
  } catch (e) {
    // If Firebase initialization fails, continue without it
    // The app will use static data as fallback
    print('Firebase initialization failed: $e');
    print('Stack trace: ${StackTrace.current}');
    useFirebase = false;
  }

  // Pass the service preference to the app
  runApp(MyApp(useFirebase: useFirebase));
}