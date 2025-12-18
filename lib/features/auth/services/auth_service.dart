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
}
