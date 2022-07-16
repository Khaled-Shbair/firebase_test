import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screen/app/notes_screen.dart';
import 'Screen/auth/forget_password_screen.dart';
import 'Screen/auth/login_screen.dart';
import 'Screen/lunch_screen.dart';
import 'Screen/auth/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/LunchScreen',
      routes: {
        '/LunchScreen': (context) => const LunchScreen(),
        '/LoginScreen': (context) => const LoginScreen(),
        '/RegisterScreen': (context) => const RegisterScreen(),
        '/ForgetPasswordScreen': (context) => const ForgetPasswordScreen(),
        '/MainScreen': (context) => const NotesScreen(),
      },
    );
  }
}
