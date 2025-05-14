// Import Flutter's material design components
import 'package:flutter/material.dart';
// Import Supabase client for database operations
import 'package:supabase_flutter/supabase_flutter.dart';

/// A registration page that allows users to create new accounts.
/// 
/// Features:
/// - Username input
/// - Phone number validation
/// - Password confirmation
/// - Integration with Supabase backend
class SignUpPage extends StatefulWidget {
  /// Creates a [SignUpPage] instance.
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers for form input fields
  final TextEditingController _usernameController = TextEditingController();  // Handles username input
  final TextEditingController _phoneController = TextEditingController();    // Handles phone number input
  final TextEditingController _passwordController = TextEditingController(); // Handles password input
  final TextEditingController _confirmPasswordController = TextEditingController(); // Handles password confirmation

  // Supabase client instance for database operations
  final supabase = Supabase.instance.client;

  /// Handles user registration process:
  /// 1. Validates all fields are filled
  /// 2. Verifies password confirmation matches
  /// 3. Creates new user record in Supabase
  /// 4. Navigates to login page on success
  /// 
  /// Shows error messages via SnackBar for:
  /// - Empty fields
  /// - Password mismatches
  /// - Database errors
  Future<void> _register() async {
    // Get trimmed input values
    final username = _usernameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validate all fields are filled
    if (username.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    // Validate password confirmation
    if (password != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    try {
      // Insert new user into Supabase
      await supabase.from('User_Information').insert({
        'name': username,    // Store username
        'phone': phone,      // Store phone number
        'password': password,// Store password (Note: In production, hash passwords)
      });

      // Show success message
      _showMessage('Registration successful!');

      // Navigate to login page if widget is still mounted
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      // Show error message if registration fails
      _showMessage('Error: $e');
    }
  }

  /// Displays a message to the user via SnackBar
  /// 
  /// [message]: The text to display in the SnackBar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),  // Page title
      body: Padding(
        padding: const EdgeInsets.all(24.0),  // Consistent padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Center form vertically
          children: [
            // Username input field
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),  // Spacer between fields
            
            // Phone number input field
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,  // Show numeric keyboard
            ),
            const SizedBox(height: 12),
            
            // Password input field
            TextField(
              controller: _passwordController,
              obscureText: true,  // Hide password characters
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 12),
            
            // Password confirmation field
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '
