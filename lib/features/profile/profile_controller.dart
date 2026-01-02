import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/models/user.dart';
import 'package:flutter_application_1/features/auth/services/auth_service.dart';

class ProfileController extends ChangeNotifier {
  final AuthService authService;

  ProfileController(this.authService);

  User? user;
  bool isLoading = false;

  Future<void> loadUser() async {
    isLoading = true;
    notifyListeners();

    user = await authService.getCurrentUser();

    isLoading = false;
    notifyListeners();
  }
}
