import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/data/repositories/crane_repository.dart';
import 'package:vinc_kiralama/domain/entities/crane.dart';
import 'package:vinc_kiralama/core/network/dio_client.dart';

// Eşleşen vinçleri getiren provider
final matchedCranesProvider = FutureProvider.family<List<Crane>, Map<String, dynamic>>((ref, criteria) async {
  final allCranes = await ref.watch(craneRepositoryProvider).getAllCranes();
  
  print('🔍 Tüm Vinçler: ${allCranes.length} adet');
  print('🔍 Seçilen Şehir: ${criteria['city']}');
  
  // Filtreleme (Şehir bazlı - case insensitive)
  final filtered = allCranes.where((crane) {
    // Şehir filtresi (ZORUNLU - büyük/küçük harf duyarsız)
    if (criteria['city'] != null) {
      final selectedCity = (criteria['city'] as String).toLowerCase().trim();
      final craneCity = (crane.city ?? '').toLowerCase().trim();
      
      if (craneCity != selectedCity) {
        return false;
      }
    }
    
    return true;
  }).toList();
  
  print('✅ Filtrelenmiş Vinçler: ${filtered.length} adet');
  for (var crane in filtered) {
    print('  - ${crane.title} (${crane.city})');
  }
  
  return filtered;
});

class MatchedCranesScreen extends ConsumerWidget {
  final Map<String, dynamic> criteria;

  const MatchedCranesScreen({super.key, required this.criteria});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cranesAsync = ref.watch(matchedCranesProvider(criteria));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uygun Vinçler', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFFFAB00),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: cranesAsync.when(
        data: (cranes) {
          if (cranes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Kriterlere uygun vinç bulunamadı',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Şehir: ${criteria['city']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAB00),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Kriterleri Değiştir'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Filtre Özeti
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.amber.shade50,
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, color: Color(0xFFFFAB00)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${cranes.length} vinç bulundu - ${criteria['city']} / ${criteria['jobType']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Vinç Listesi
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cranes.length,
                  itemBuilder: (context, index) {
                    final crane = cranes[index];
                    return Consumer(
                      builder: (context, ref, child) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.construction, size: 40, color: Color(0xFFFFAB00)),
                            title: Text(crane.title ?? 'Vinç ${index + 1}', 
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${crane.city ?? "Şehir yok"} - ${crane.capacityTon ?? 0} Ton\nKategori: ${crane.categoryName ?? "Yok"}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('₺${(crane.dailyPrice ?? 0).toStringAsFixed(0)}', 
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                                const Text('/gün', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            onTap: () async {
                              // Teklif isteği gönder
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Teklif İste'),
                                  content: Text('${crane.title} için teklif isteği göndermek istiyor musunuz?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('İptal'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(ctx);
                                        
                                        // Loading göster
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (ctx) => const Center(child: CircularProgressIndicator()),
                                        );
                                        
                                        try {
                                          // API'ye teklif gönder
                                          final dio = ref.read(dioClientProvider).dio;
                                          
                                          print('📤 Teklif Gönderiliyor - Email: ${criteria['email']}');
                                          print('📤 Teklif Data: $criteria');
                                          
                                          await dio.post('/api/mobile/offers/request-quote', data: {
                                            'jobType': criteria['jobType'],
                                            'jobDescription': criteria['jobDescription'],
                                            'city': criteria['city'],
                                            'district': criteria['district'],
                                            'siteType': criteria['siteType'],
                                            'accessType': criteria['accessType'],
                                            'heightMeters': criteria['heightMeters'],
                                            'loadWeightKg': criteria['loadWeightKg'],
                                            'duration': criteria['duration'],
                                            'jobStartDate': criteria['jobStartDate']?.toIso8601String(),
                                            'customerName': criteria['customerName'],
                                            'phone': criteria['phone'],
                                            'email': criteria['email'],
                                            'companyName': criteria['companyName'],
                                            'notes': criteria['notes'],
                                            'craneId': crane.id,
                                            'firmId': crane.firmId,
                                          });
                                          
                                          if (context.mounted) {
                                            Navigator.pop(context); // Loading kapat
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Teklif isteğiniz firmaya iletildi! ✅'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            Navigator.pop(context); // Loading kapat
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Hata: ${e.toString()}'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Text('GÖNDER'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
    );
  }
}

class _CraneCard extends StatelessWidget {
  final Crane crane;
  final Map<String, dynamic> criteria;

  const _CraneCard({required this.crane, required this.criteria});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resim
          if (crane.imageUrls.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                crane.imageUrls.first,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.construction, size: 64, color: Colors.grey),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık ve Kategori
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        crane.title ?? 'İsimsiz Vinç',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        crane.categoryName ?? 'Kategori Yok',
                        style: const TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Açıklama
                Text(
                  crane.description ?? 'Açıklama yok',
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Özellikler
                Row(
                  children: [
                    const Icon(Icons.fitness_center, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${crane.capacityTon ?? 0} Ton'),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(crane.city ?? 'Şehir Yok'),
                  ],
                ),
                const SizedBox(height: 12),

                // Fiyat ve Buton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Günlük Fiyat', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(
                          '₺${(crane.dailyPrice ?? 0).toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _sendQuoteRequest(context, crane);
                      },
                      icon: const Icon(Icons.send, size: 18),
                      label: const Text('TEKLİF İSTE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendQuoteRequest(BuildContext context, Crane crane) {
    // Teklif isteği gönder
    // Backend'e POST /api/mobile/offers/request-quote
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Teklif İsteği'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${crane.title} için teklif isteği göndermek istediğinize emin misiniz?'),
            const SizedBox(height: 16),
            Text('Firma: ${crane.firmName ?? "Belirtilmemiş"}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Fiyat: ₺${crane.dailyPrice}/gün'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Backend'e teklif isteği gönder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Teklif isteğiniz firmaya iletildi! ✅'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context); // MatchedCranesScreen'den çık
            },
            child: const Text('GÖNDER'),
          ),
        ],
      ),
    );
  }
}
