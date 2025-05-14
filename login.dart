import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A login page that authenticates users via phone and password using Supabase.
/// 
/// This widget provides:
/// - Phone number input (validated for non-empty values)
/// - Password input (obscured for security)
/// - Integration with Supabase backend for credential verification
/// - Error handling for empty inputs and failed authentication
class LoginPage extends StatefulWidget {
  /// Creates a [LoginPage] instance.
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Controller for phone number input field
  final TextEditingController _phoneController = TextEditingController();
  
  /// Controller for password input field
  final TextEditingController _passwordController = TextEditingController();

  /// Supabase client instance for database operations
  final supabase = Supabase.instance.client;

  /// Attempts user login with provided credentials.
  /// 
  /// Validates that both phone and password fields are non-empty before
  /// querying Supabase. Navigates to '/main' route on success, shows error
  /// messages for:
  /// - Empty fields
  /// - Invalid credentials
  /// - Network/database errors
  /// 
  /// Throws [Exception] if no matching user is found.
  Future<void> _login() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    // Validate non-empty inputs
    if (phone.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone and password cannot be empty.')),
      );
      return;
    }

    try {
      // Query Supabase for matching user
      final response = await supabase
          .from('User_Information')
          .select()
          .eq('phone', phone)
          .eq('password', password)
          .single();

      if (!mounted) return;

      if (response != null) {
        // Successful login - navigate to main app
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        throw Exception('No user found with these credentials');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Phone input field
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter your registered phone number',
              ),
            ),
            const SizedBox(height: 12),
            
            // Password input field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
            const SizedBox(height: 24),
            
            // Login button
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
