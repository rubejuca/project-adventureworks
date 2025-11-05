import 'package:flutter/material.dart';
import 'package:adventure_works/features/auth/login_page.dart';
import 'package:adventure_works/features/products/products_page.dart';
import 'package:adventure_works/features/products/pages/create_product_page.dart'; // Add this import
import 'package:adventure_works/features/dashboard/dashboard_page.dart'; // Add this import
import 'package:adventure_works/services/theme_service.dart';
import 'package:adventure_works/services/product_service_firebase.dart';
import 'package:adventure_works/services/product_service_static.dart';

class MyApp extends StatefulWidget {
  final bool useFirebase;
  
  const MyApp({super.key, required this.useFirebase});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdventureWorks',
      theme: ThemeService.lightTheme,
      darkTheme: ThemeService.darkTheme,
      themeMode: _themeService.themeMode,
      initialRoute: LoginPage.route,
      routes: {
        LoginPage.route: (context) => const LoginPage(),
        ProductsPage.route: (context) => ProductsPage(useFirebase: widget.useFirebase),
        CreateProductPage.route:
            (context) => const CreateProductPage(), // Add this route
        '/dashboard': (context) => DashboardPage(useFirebase: widget.useFirebase),
      },
    );
  }
}