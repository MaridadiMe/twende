import 'package:flutter_application_1/features/auth/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'access_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;

    try {
      return !Jwt.isExpired(token);
    } catch (_) {
      return false;
    }
  }

  static Future<User?> getCurrentUser() async {
    final token = await getToken();

    if (token == null) {
      return null;
    }

    try {
      final payload = Jwt.parseJwt(token);

      return User.fromJwt(payload);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
  }
}
