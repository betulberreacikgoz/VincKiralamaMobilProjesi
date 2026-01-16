import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/core/network/dio_client.dart';
import 'package:vinc_kiralama/domain/entities/user.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return AuthRemoteDataSource(dio);
});

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<User> loginAdmin(String email, String password) async {
    try {
      final response = await _dio.post('/api/mobile/auth/login/admin', data: {
        'email': email,
        'password': password,
      });

      print("📥 API RESPONSE (Admin): ${response.data}");
      
      // Backend 'Id' ve 'Email' dönmüyorsa manuel ekleyelim
      final data = response.data as Map<String, dynamic>;
      
      return User(
        id: data['Id']?.toString() ?? data['id']?.toString() ?? '1', 
        email: data['Email'] ?? data['email'] ?? email, 
        role: data['Role'] ?? data['role'] ?? 'Admin',
        token: data['Token'] ?? data['token'],
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Admin şifresi hatalı!");
      }
      throw Exception("Bağlantı hatası: ${e.message}");
    }
  }

  // Müşteri Girişi
  Future<User> loginCustomer(String email, String password) async {
    try {
      final response = await _dio.post('/api/mobile/auth/login/customer', data: {
        'email': email,
        'password': password,
      });

      return User(
        id: response.data['id']?.toString() ?? response.data['Id']?.toString() ?? '0',
        email: email, // Backend'den gelmese bile parametre olarak gelen email'i kullan
        role: 'Customer',
        token: response.data['token'] ?? response.data['Token'] ?? '',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Email veya şifre hatalı!");
      }
      throw Exception("Bağlantı hatası: ${e.message}");
    }
  }

  // Müşteri Kaydı
  Future<Map<String, dynamic>> registerCustomer({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/api/mobile/auth/register/customer', data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      });

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is String) {
        throw Exception(e.response!.data);
      }
      throw Exception("Kayıt başarısız: ${e.message}");
    }
  }

  // GERÇEK API BAĞLANTISI (FIRMA İÇİN)
  Future<User> loginFirm(String email, String firmKey) async {
    try {
      // Backend'deki yeni endpoint'e istek atıyoruz
      // DİKKAT: .env dosyasındaki IP adresinin doğru olduğundan emin olun!
      final response = await _dio.post('/api/mobile/auth/login/firm', data: {
        'email': email,
        'apiKey': firmKey,
      });
      
      print("📥 API RESPONSE: ${response.data}");
      
      // Backend'den gelen JSON yapısına göre User oluşturuyoruz
      /*
        Beklenen Backend Cevabı:
        {
          "id": "5",
          "email": "info@abc.com",
          "role": "Firma",
          "firmName": "ABC Vinç",
          "token": "..."
        }
      */
      return User.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Firma bilgileri veya anahtar hatalı!");
      }
      throw Exception("Bağlantı hatası: ${e.message}");
    }
  }

  Future<Map<String, dynamic>> registerFirm(Map<String, dynamic> firmData) async {
    try {
      final response = await _dio.post('/api/mobile/auth/register/firm', data: firmData);
      print("📥 REGISTER FIRM RESPONSE: ${response.data}");
      return response.data; 
    } on DioException catch (e) {
      print("❌ FIRM REGISTER ERROR: ${e.message}");
      if (e.response != null) {
         print("   Response: ${e.response?.data}");
         if (e.response?.data != null) {
           throw Exception(e.response?.data.toString()); // Backend mesajını göster
         }
      }
      throw Exception("Başvuru hatası: ${e.message}");
    }
  }

  // YENİ: Admin için Tüm Firmaları Listele
  Future<List<dynamic>> getAllFirms() async {
    try {
      final response = await _dio.get('/api/mobile/auth/all-firms'); 
      
      // Backend null veya boş dönerse patlamasın, boş liste dönsün
      if (response.data == null) {
        return [];
      }
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
      
    } on DioException catch (e) {
      throw Exception("Firma listesi alınamadı: ${e.message}");
    }
  }

  // YENİ: Admin için Firmayı Onayla
  Future<void> approveFirm(int id) async {
    try {
      await _dio.post('/api/mobile/auth/approve-firm/$id');
    } on DioException catch (e) {
      throw Exception("Onaylama hatası: ${e.message}");
    }
  }
}
