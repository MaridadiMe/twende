import 'package:flutter_application_1/features/auth/models/user.dart';
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

  Future<void> logout() async {
    await AuthStorage.clear();
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
