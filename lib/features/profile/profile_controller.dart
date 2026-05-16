import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/classes/app_state.dart';
import 'package:flutter_application_1/features/auth/classes/session_manager.dart';
import 'package:flutter_application_1/features/auth/enums/app_mode.dart';
import 'package:flutter_application_1/features/auth/models/user.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';

class ProfileController extends ChangeNotifier {
  final AuthService authService;
  User? user;
  bool isLoading = false;
  bool _initialized = false;

  ProfileController(this.authService);

  Future<void> init() async {
    if (_initialized) return;

    _initialized = true;

    user = SessionManager.currentUser;
    notifyListeners();
  }

  Future<void> switchMode(AppMode mode) async {
    AppState.mode = mode;
    notifyListeners();
  }

  Future<void> refresh() async {
    isLoading = true;
    notifyListeners();

    user = SessionManager.currentUser;

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    await authService.logout();

    isLoading = false;
    notifyListeners();
  }
}
