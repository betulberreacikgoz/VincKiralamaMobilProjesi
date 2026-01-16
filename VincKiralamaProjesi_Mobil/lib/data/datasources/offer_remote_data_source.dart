import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/core/network/dio_client.dart';
import 'package:vinc_kiralama/domain/entities/offer.dart';
import 'package:vinc_kiralama/presentation/auth/auth_controller.dart';

final offerRemoteDataSourceProvider = Provider<OfferRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final authAsync = ref.watch(authStateProvider);
  final firmId = authAsync.whenData((user) => user?.id).value;
  return OfferRemoteDataSource(dioClient.dio, firmId);
});

class OfferRemoteDataSource {
  final Dio _dio;
  final String? _firmId;

  OfferRemoteDataSource(this._dio, this._firmId);

  Future<List<Offer>> getIncomingOffers() async {
    try {
      print('🏢 FirmId: $_firmId');
      
      final options = Options(
        headers: _firmId != null ? {'FirmId': _firmId} : {},
      );
      
      print('🌐 GET /api/mobile/offers/incoming with headers: ${options.headers}');
      
      final response = await _dio.get('/api/mobile/offers/incoming', options: options);
      
      print('✅ Incoming Offers Response: ${response.data}');
      
      return (response.data as List).map((e) => Offer.fromJson(e)).toList();
    } on DioException catch (e) {
      print("❌ GET OFFERS ERROR: ${e.message}");
      print("❌ Response: ${e.response?.data}");
      throw Exception("Teklifler yüklenemedi: ${e.message}");
    }
  }

  Future<void> acceptOffer(int id) async {
    try {
      await _dio.post('/api/mobile/offers/$id/accept');
    } on DioException catch (e) {
      throw Exception("Teklif kabul edilemedi: ${e.message}");
    }
  }

  Future<void> rejectOffer(int id) async {
    try {
      await _dio.post('/api/mobile/offers/$id/reject');
    } on DioException catch (e) {
      throw Exception("Teklif reddedilemedi: ${e.message}");
    }
  }
}
