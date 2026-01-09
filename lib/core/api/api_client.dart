import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../auth/auth_storage.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.rosemlabs.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  /// 🔴 Centralized API error message extractor
  static String extractErrorMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      return data['error']?['message'] ?? data['message'] ?? 'Request failed';
    }

    return e.message ?? 'Network error occurred';
  }

  void _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await AuthStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    debugPrint('➡️ REQUEST');
    debugPrint('${options.method} ${options.uri}');
    debugPrint('Headers: ${options.headers}');
    debugPrint('Query: ${options.queryParameters}');
    debugPrint('Body: ${options.data}');
    handler.next(options);
  }

  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('⬅️ OK');
    debugPrint('URL: ${response.requestOptions.uri}');
    debugPrint('Status: ${response.statusCode}');
    debugPrint('Data: ${response.data}');
    handler.next(response);
  }

  void _onError(DioException error, ErrorInterceptorHandler handler) {
    debugPrint('❌ ERROR');
    debugPrint('URL: ${error.requestOptions.uri}');
    debugPrint('Message: ${extractErrorMessage(error)}');
    debugPrint('Raw: ${error.response?.data}');
    handler.next(error);
  }
}
