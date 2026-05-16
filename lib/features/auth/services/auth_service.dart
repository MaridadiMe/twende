import 'package:flutter_application_1/features/auth/classes/app_state.dart';
import 'package:flutter_application_1/features/auth/classes/session_manager.dart';
import 'package:flutter_application_1/features/auth/enums/app_mode.dart';
import 'package:flutter_application_1/features/auth/models/register_user_dto.dart';
import 'package:flutter_application_1/features/auth/models/request_otp_dto.dart';
import 'package:flutter_application_1/features/auth/models/user.dart';
import 'package:flutter_application_1/features/auth/models/verify_otp_dto.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../../core/api/api_client.dart';
import '../../../core/auth/auth_storage.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<void> login({required String email, required String password}) async {
    final response = await _apiClient.dio.post(
      '/api/v1/iam/auth/login',
      data: {'email': email, 'password': password},
    );

    final token = response.data['data']['accessToken'];
    if (token == null) {
      throw Exception('Invalid login response');
    }

    await AuthStorage.saveToken(token);
  }

  Future<User> register(RegisterUserDto payload) async {
    final response = await _apiClient.dio.post(
      '/api/v1/iam/users',
      data: payload.toJson(),
    );

    final data = response.data['data'];

    return User.fromJson(data);
  }

  Future<void> logout() async {
    await AuthStorage.clear();
    SessionManager.currentUser = null;
    AppState.mode = AppMode.rider;
  }

  Future<void> verifyOtp(VerifyOtpDto payload) async {
    await _apiClient.dio.post(
      '/api/v1/iam/users/confirm-phone',
      data: payload.toJson(),
    );
  }

  Future<void> requestOtp(RequestOtpDto payload) async {
    await _apiClient.dio.post(
      '/api/v1/iam/users/verify-phone',
      data: payload.toJson(),
    );
  }

  /// 🔹 Get logged-in user from JWT
  Future<User?> getCurrentUser() async {
    final token = await AuthStorage.getToken();
    if (token == null) return null;

    // 🔐 Expiry check (built-in)
    if (Jwt.isExpired(token)) {
      await logout();
      return null;
    }

    final payload = Jwt.parseJwt(token);
    return User.fromJwt(payload);
  }
}
