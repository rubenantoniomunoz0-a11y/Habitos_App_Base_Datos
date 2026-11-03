import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const HabitosApp());
}

class HabitosApp extends StatelessWidget {
  const HabitosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitosApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      // La app arranca directamente en la pantalla de Login
      home: const LoginScreen(),
    );
  }
}