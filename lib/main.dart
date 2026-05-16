import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/dark_theme.dart';
import 'package:flutter_application_1/core/theme/light_theme.dart';
import 'package:flutter_application_1/features/auth/auth_gate.dart';
import 'package:flutter_application_1/features/auth/screens/login_screen.dart';
import 'package:flutter_application_1/features/auth/screens/register_screen.dart';
import 'package:flutter_application_1/features/home/home_screen.dart';
import 'package:flutter_application_1/features/home/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(MyApp());
}

Future<void> _initializeApp() async {
  try {
    // ─── Critical initializations (do these first) ────────
    // await Firebase.initializeApp();
    // await Supabase.initialize(...);
    // await Hive.initFlutter();
    // await GetStorage.init();
    // await SharedPreferences.getInstance();  // ← very common

    // ─── Parallelize independent work when possible ───────
    //await Future.wait([
    // precache images / fonts if you have custom ones
    // _precacheAssets(),
    // initialize analytics / crashlytics (non-blocking is better)
    // setup local notifications,
    // check in-app purchases / restore purchases,
    // check deep link / initial route (uni_links / app_links),
    // load remote config / feature flags,
    //]);

    // Optional: artificial minimum delay (only if everything else is < 1.5 s)
    await Future.delayed(const Duration(seconds: 2));
  } catch (e, stack) {
    // Very important in production!
    // log to Crashlytics / Sentry / your backend
    debugPrint("App initialization failed: $e\n$stack");
    // You can later show error screen instead of main UI
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "YaTown",
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: const AuthGate(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/app': (_) => const MainShell(),
      },
    );
  }
}

class SearchTripsScreen {
  const SearchTripsScreen();
}
