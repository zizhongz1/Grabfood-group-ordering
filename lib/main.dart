import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'welcome.dart';
import 'sign_up.dart';
import 'login.dart';
// I Love Dogs.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wvzavonbysucsraqtbsu.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind2emF2b25ieXN1Y3NyYXF0YnN1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwNTkyOTMsImV4cCI6MjA2MjYzNTI5M30.58p-1KOxXtdsz9CUKo2Bj9rYToX8Qf1wka46HOiO3Rs',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XinhaoFanFan App',
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