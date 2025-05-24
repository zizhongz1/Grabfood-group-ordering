import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'welcome.dart';
import 'sign_up.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: 'https://wvzavonbysucsraqtbsu.supabase.co',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XinhaoFanFan',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const WelcomePage(),
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}