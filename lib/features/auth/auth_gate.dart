import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/classes/session_boostrap.dart';
import 'package:flutter_application_1/features/auth/models/user.dart';
import 'package:flutter_application_1/features/auth/screens/login_screen.dart';
import 'package:flutter_application_1/features/home/main_shell.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<User?> _init() async {
    return await SessionBootstrap.init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        return const MainShell();
      },
    );
  }
}
