import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/core/network/dio_client.dart';
import 'package:vinc_kiralama/presentation/auth/auth_controller.dart';

// Müşterinin tekliflerini getiren provider
final myQuotesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(authStateProvider).value;
  
  print('🔍 MyQuotes - User: ${user?.email}');
  
  if (user == null || user.email.isEmpty) {
    print('❌ MyQuotes - User null veya email boş');
    return [];
  }

  final dio = ref.read(dioClientProvider).dio;
  
  print('🌐 MyQuotes - API çağrısı yapılıyor: ${user.email}');
  
  final response = await dio.get('/api/mobile/offers/my-quotes', queryParameters: {
    'customerEmail': user.email,
  });

  print('✅ MyQuotes - Response: ${response.data}');
  
  return List<Map<String, dynamic>>.from(response.data);
});

class MyQuotesScreen extends ConsumerWidget {
  const MyQuotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotesAsync = ref.watch(myQuotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tekliflerim', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFFFAB00),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: quotesAsync.when(
        data: (quotes) {
          if (quotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Henüz teklif isteğiniz yok',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vinç kiralama sayfasından teklif alabilirsiniz',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.construction),
                    label: const Text('Vinç Kirala'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFAB00),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myQuotesProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final quote = quotes[index];
                return _QuoteCard(quote: quote);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Hata: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(myQuotesProvider),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final Map<String, dynamic> quote;

  const _QuoteCard({required this.quote});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'kabul edildi':
        return Colors.green;
      case 'reddedildi':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'kabul edildi':
        return Icons.check_circle;
      case 'reddedildi':
        return Icons.cancel;
      default:
        return Icons.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = quote['status'] ?? 'Beklemede';
    final jobType = quote['jobType'] ?? 'Belirtilmemiş';
    final city = quote['city'] ?? '';
    final district = quote['district'] ?? '';
    final craneName = quote['craneName'] ?? 'Henüz atanmadı';
    final firmName = quote['firmName'] ?? 'Henüz atanmadı';
    final createdAt = quote['createdAt'] ?? '';
    final jobStartDate = quote['jobStartDate'] ?? '';
    final duration = quote['duration'] ?? '';
    final description = quote['jobDescription'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık ve Durum
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    jobType,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(status)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getStatusIcon(status), size: 16, color: _getStatusColor(status)),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Konum
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  district.isNotEmpty ? '$city, $district' : city,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Açıklama
            if (description.isNotEmpty) ...[
              Text(
                description,
                style: const TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],

            const Divider(),
            const SizedBox(height: 8),

            // Vinç ve Firma Bilgisi
            Row(
              children: [
                const Icon(Icons.construction, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    craneName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.business, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    firmName,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tarih Bilgileri
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('İş Başlangıç', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(jobStartDate, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Süre', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(duration, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Talep Tarihi', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      createdAt.isNotEmpty ? createdAt.substring(0, 10) : '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
