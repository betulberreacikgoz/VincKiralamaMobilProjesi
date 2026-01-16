import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vinc_kiralama/core/env.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

class DioClient {
  late final Dio dio;
  final _storage = const FlutterSecureStorage();

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 30), // 30 saniyeye çıkardık
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    // SSL sertifikası hatası (HTTPS) almamak için (Geliştirme ortamı)

    if (!kIsWeb && dio.httpClientAdapter is IOHttpClientAdapter) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Tam URL'i yazdıralım ki nereye gittiğini görelim
          print("🌐 [API REQUEST] ${options.method} ${options.uri}"); 
          print("   Data: ${options.data}");
          return handler.next(options);
        },
        onError: (DioException e, handler) {
           print("❌ [API ERROR] ${e.message}");
           print("   URL: ${e.requestOptions.uri}");
           print("   Response: ${e.response?.data}");

           // Web için özel hata mesajı (CORS veya Bağlantı Hatası)
           if (kIsWeb && e.type == DioExceptionType.unknown) {
             print("⚠️ [WEB WARNING] Bu hata genellikle CORS (Cross-Origin Resource Sharing) kaynaklıdır.");
             print("   Backend API'nizde (Program.cs) CORS'u etkinleştirmeyi unutmayın.");
             print("   Veya API kapalı olabilir / IP adresi erişilebilir olmayabilir.");
           }

           return handler.next(e);
        },
      ),
    );
  }
}
