import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/core/network/dio_client.dart';
import 'package:vinc_kiralama/domain/entities/crane.dart';
import 'package:vinc_kiralama/domain/entities/category.dart';
import 'package:vinc_kiralama/presentation/auth/auth_controller.dart';

final craneRemoteDataSourceProvider = Provider<CraneRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  // AuthState'den firmId'yi al
  final authAsync = ref.watch(authStateProvider);
  final firmId = authAsync.whenData((user) => user?.id).value;
  return CraneRemoteDataSource(dioClient.dio, firmId);
});

class CraneRemoteDataSource {
  final Dio _dio;
  final String? _firmId; // Giriş yapan firmanın ID'si

  CraneRemoteDataSource(this._dio, this._firmId);

  // Yardımcı Dönüştürücü Metod
  Crane _mapJsonToCrane(Map<String, dynamic> json) {
    // Backend 'Name' gönderiyor, Flutter 'title' bekliyor
    // Backend 'ImageUrl' (String) gönderiyor, Flutter 'imageUrls' (List) bekliyor
    // Backend 'Category.Name' -> categoryName

    return Crane(
      id: json['id'] ?? 0,
      title: json['name'] ?? json['title'] ?? 'İsimsiz Vinç',
      description: json['description'] ?? '',
      capacityTon: (json['capacityTon'] as num?)?.toDouble() ?? 0.0,
      dailyPrice: (json['dailyPrice'] as num?)?.toDouble() ?? 0.0,
      city: json['city'] ?? '',
      // İlişkili tablodan kategori adı gelebilir veya direkt categoryName
      categoryName: json['category'] != null ? json['category']['name'] : (json['categoryName'] ?? 'Genel'),
      firmId: json['firmId'] ?? 0,
      firmName: json['firm'] != null ? json['firm']['name'] : null,
      
      // Tekil ImageUrl'i listeye çevir
      imageUrls: json['imageUrl'] != null && json['imageUrl'].toString().isNotEmpty 
          ? [json['imageUrl']] 
          : [],
    );
  }

  Future<List<Crane>> getAllCranes() async {
    try {
      final response = await _dio.get('/api/mobile/cranes');
      return (response.data as List).map((e) => _mapJsonToCrane(e)).toList();
    } on DioException catch (e) {
      print("❌ GET ALL CRANES ERROR: ${e.message}");
      // Hatanın UI'da görünmesi için fırlatıyoruz
      throw Exception("Vinçler yüklenirken hata: ${e.message} (${e.response?.statusCode})");
    }
  }

  Future<List<Crane>> getMyCranes() async {
    try {
      // Firma ID'sini header olarak gönder
      final options = Options(
        headers: _firmId != null ? {'FirmId': _firmId} : {},
      );
      
      final response = await _dio.get('/api/mobile/cranes/my', options: options);
      return (response.data as List).map((e) => _mapJsonToCrane(e)).toList();
    } on DioException catch (e) {
       print("❌ GET MY CRANES ERROR: ${e.message}");
       // Hata detayını görelim
       throw Exception("Vinçlerim yüklenemedi: ${e.message}");
    }
  }

  Future<void> addCrane(Crane crane) async {
    try {
      await _dio.post('/api/mobile/cranes', data: crane.toJson());
    } on DioException catch (e) {
      String msg = e.message ?? 'Bilinmeyen Hata';
      if (e.response?.data != null) {
        // Backend'den gelen detaylı hata mesajını yakala
        // API { "Message": "...", "Detail": "..." } dönüyor olabilir
        final data = e.response?.data;
        if (data is Map && data['Detail'] != null) {
          msg = "${data['Message']} : ${data['Detail']}";
        } else if (data is Map && data['Message'] != null) {
          msg = data['Message'];
        } else {
          msg = data.toString();
        }
      }
      throw Exception("Hata: $msg");
    }
  }
  
  Future<void> updateCrane(Crane crane) async {
    try {
      await _dio.put('/api/mobile/cranes/${crane.id}', data: crane.toJson());
    } on DioException catch (e) {
      throw Exception("Vinç güncellenirken hata: ${e.message}");
    }
  }

  Future<void> deleteCrane(int id) async {
    try {
      await _dio.delete('/api/mobile/cranes/$id');
    } on DioException catch (e) {
      throw Exception("Vinç silinirken hata: ${e.message}");
    }
  }

  Future<List<Category>> getCategories() async {
     try {
      final response = await _dio.get('/api/mobile/categories');
      return (response.data as List).map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      // Mock Categories if fail
      return [
         const Category(id: 1, name: 'Mobil Vinç', imageUrl: ''),
         const Category(id: 2, name: 'Hiyap', imageUrl: ''),
         const Category(id: 3, name: 'Sepetli Vinç', imageUrl: ''),
      ];
    }
  }
}
