import 'package:flutter_application_1/core/auth/auth_storage.dart';
import 'package:flutter_application_1/features/auth/classes/app_state.dart';
import 'package:flutter_application_1/features/auth/classes/session_manager.dart';
import 'package:flutter_application_1/features/auth/enums/app_mode.dart';
import 'package:flutter_application_1/features/auth/models/user.dart';

class SessionBootstrap {
  static Future<User?> init() async {
    final isValid = await AuthStorage.isTokenValid();

    if (!isValid) return null;

    final user = await AuthStorage.getCurrentUser();

    if (user == null) return null;

    SessionManager.currentUser = user;

    AppState.mode = user.hasPermission('CREATE_TRIPS')
        ? AppMode.driver
        : AppMode.rider;

    return user;
  }
}
