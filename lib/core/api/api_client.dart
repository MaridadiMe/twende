import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../auth/auth_storage.dart';

// class ApiClient {
//   late final Dio dio;

//   ApiClient() {
//     dio = Dio(
//       BaseOptions(
//         baseUrl: 'https://api.rosemlabs.com', // TODO: change
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//         headers: {'Content-Type': 'application/json'},
//       ),
//     );

//     // JWT interceptor
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           final token = await AuthStorage.getToken();
//           if (token != null) {
//             options.headers['Authorization'] = 'Bearer $token';
//           }
//           handler.next(options);
//         },
//         onError: (error, handler) {
//           handler.next(error);
//         },
//       ),
//     );
//   }
// }

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.rosemlabs.com', // TODO: change
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    /// JWT interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          /// 🔍 REQUEST LOG
          debugPrint('➡️ REQUEST');
          debugPrint('${options.method} ${options.uri}');
          debugPrint('Headers: ${options.headers}');
          debugPrint('Query: ${options.queryParameters}');
          debugPrint('Body: ${options.data}');

          handler.next(options);
        },
        onResponse: (response, handler) {
          /// ✅ RESPONSE LOG
          debugPrint('⬅️ RESPONSE');
          debugPrint('URL: ${response.requestOptions.uri}');
          debugPrint('Status: ${response.statusCode}');
          debugPrint('Data: ${response.data}');

          handler.next(response);
        },
        onError: (error, handler) {
          /// ❌ ERROR LOG
          debugPrint('❌ ERROR');
          debugPrint('URL: ${error.requestOptions.uri}');
          debugPrint('Message: ${error.message}');
          debugPrint('Response: ${error.response?.data}');

          handler.next(error);
        },
      ),
    );
  }
}
