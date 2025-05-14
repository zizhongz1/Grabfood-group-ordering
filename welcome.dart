// Import Flutter's material design components
import 'package:flutter/material.dart';
// Import the sign-up page for route configuration
import 'sign_up.dart';

/// The main entry point of the application
void main() {
  // Launch the application with MyApp as the root widget
  runApp(const MyApp());
}

/// The root widget of the application that configures:
/// - MaterialApp with green theme
/// - WelcomePage as initial screen
/// - Named routes for navigation
class MyApp extends StatelessWidget {
  /// Creates the root application widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Disable debug banner in release mode
      title: 'XinhaoFanfan App',         // Application title
      theme: ThemeData(
        primarySwatch: Colors.green,     // Primary color scheme
      ),
      home: const WelcomePage(),        // Initial screen widget
      routes: {
        '/signup': (context) => const SignUpPage(), // Registration screen route
      },
    );
  }
}

/// The welcome/landing page of the application that provides:
/// - Brand introduction
/// - Call-to-action buttons for sign-up/login
class WelcomePage extends StatelessWidget {
  /// Creates a welcome page instance
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // White background for clean look
      body: Padding(
        padding: const EdgeInsets.all(24.0),  // Consistent padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Center content vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            // Application title text
            const Text(
              'Welcome to xinhaofanfan',
              style: TextStyle(
                fontSize: 28,              // Large font size for heading
                fontWeight: FontWeight.bold, // Bold weight for emphasis
              ),
              textAlign: TextAlign.center, // Center-aligned text
            ),
            const SizedBox(height: 16),    // Spacer between text elements
            
            // Subtitle text
            const Text(
              'Start your convenient and affordable ordering experience.',
              style: TextStyle(
                fontSize: 18,             // Medium font size for subtitle
                color: Colors.grey        // Grey color for secondary text
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),    // Larger spacer before buttons
            
            // Sign Up button (primary action)
            ElevatedButton(
              onPressed: () {
                // Navigate to sign-up page when pressed
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48), // Full-width button with fixed height
              ),
              child: const Text('Sign Up'), // Button label
            ),
            const SizedBox(height: 16),    // Spacer between buttons
            
            // Log In button (secondary action)
            OutlinedButton(
              onPressed: () {
                // Navigate to login page when pressed
                Navigator.pushNamed(context, '/login');
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48), // Match sign-up button dimensions
              ),
              child: const Text('Log In'), // Button label
            ),
          ],
        ),
      ),
    );
  }
}
