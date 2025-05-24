import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final supabase = Supabase.instance.client;

  String? _verificationId;
  bool _isPhoneVerified = false;
  bool _isVerifying = false;

  Future<void> _sendCode() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showMessage('Please enter your phone number');
      return;
    }
    setState(() {
      _isVerifying = true;
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        setState(() {
          _isPhoneVerified = true;
          _isVerifying = false;
        });
        _showMessage('Phone number automatically verified!');
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _isVerifying = false;
        });
        _showMessage('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isVerifying = false;
        });
        _showMessage('OTP sent. Please check your phone.');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _verifyCode() async {
    if (_verificationId == null) {
      _showMessage('Please request an OTP first.');
      return;
    }
    final smsCode = _otpController.text.trim();
    if (smsCode.isEmpty) {
      _showMessage('Please enter the OTP.');
      return;
    }
    setState(() {
      _isVerifying = true;
    });
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _isPhoneVerified = true;
        _isVerifying = false;
      });
      _showMessage('Phone number verified!');
    } catch (e) {
      setState(() {
        _isVerifying = false;
      });
      _showMessage('Invalid OTP. Please try again.');
    }
  }

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    if (!_isPhoneVerified) {
      _showMessage('Please verify your phone number first.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    try {
      await supabase.from('User_Information').insert({
        'name': username,
        'phone': phone,
        'password': password,
      });

      _showMessage('Registration successful!');

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      _showMessage('Error: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                enabled: !_isPhoneVerified,
              ),
              const SizedBox(height: 8),
              if (!_isPhoneVerified) ...[
                ElevatedButton(
                  onPressed: _isVerifying ? null : _sendCode,
                  child: Text(_isVerifying ? 'Sending...' : 'Send OTP'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _otpController,
                  decoration: const InputDecoration(labelText: 'Enter OTP'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyCode,
                  child: Text(_isVerifying ? 'Verifying...' : 'Verify'),
                ),
              ],
              if (_isPhoneVerified)
                const Text('Phone number verified!', style: TextStyle(color: Colors.green)),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}