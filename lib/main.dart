import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/auth_gate.dart';
import 'package:flutter_application_1/features/auth/screens/login_screen.dart';
import 'package:flutter_application_1/features/auth/screens/register_screen.dart';
import 'package:flutter_application_1/features/home/home_screen.dart';
import 'package:flutter_application_1/features/trips/screens/search_trip_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  //await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ride Sharing App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const AuthGate(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/search-trips': (_) => const SearchTripScreen(),
        // '/schedule-trip': (_) => const ScheduleTripScreen(),
      },
    );
  }
}

class SearchTripsScreen {
  const SearchTripsScreen();
}
