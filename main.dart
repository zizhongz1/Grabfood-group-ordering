// Main entry point for the Flutter application
import 'package:flutter/material.dart';
// Supabase integration package for Flutter
import 'package:supabase_flutter/supabase_flutter.dart';
// Application screens/pages
import 'welcome.dart';      // Welcome/landing screen
import 'sign_up.dart';      // User registration screen
import 'login.dart';        // User authentication screen

/// The main asynchronous function that initializes and runs the Flutter app.
/// 
/// Initializes:
/// 1. Flutter engine bindings
/// 2. Supabase client with project configuration
/// 3. Root application widget (MyApp)
Future<void> main() async {
  // Ensures Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase client with project credentials
  await Supabase.initialize(
    url: 'https://wvzavonbysucsraqtbsu.supabase.co',  // Supabase project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind2emF2b25ieXN1Y3NyYXF0YnN1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwNTkyOTMsImV4cCI6MjA2MjYzNTI5M30.58p-1KOxXtdsz9CUKo2Bj9rYToX8Qf1wka46HOiO3Rs',  // Public anonymous key
  );

  // Launch the application with MyApp as the root widget
  runApp(const MyApp());
}

/// The root widget of the application.
/// 
/// Configures:
/// - MaterialApp with green theme
/// - WelcomePage as initial screen
/// - Named routes for navigation
class MyApp extends StatelessWidget {
  /// Creates the root application widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Disables debug banner
      title: 'XinhaoFanFan App',         // Application title
      theme: ThemeData(
        primarySwatch: Colors.green,     // Primary color scheme
      ),
      home: const WelcomePage(),         // Initial screen widget
      routes: {                          // Named route configuration
        '/signup': (context) => const SignUpPage(),  // Sign-up screen route
        '/login': (context) => const LoginPage(),    // Login screen route
      },
    );
  }
}
