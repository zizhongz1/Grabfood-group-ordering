import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); // 

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Tips"),
          content: const Text("Username or password cannot be empty!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Confirm"),
            )
          ],
        ),
      );
      return;
    }

    debugPrint("Login Successfully：$username / $password"); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")), 
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
