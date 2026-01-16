import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/presentation/customer/my_quotes_screen.dart';

// Geçmiş işleri getiren provider (Kabul edilmiş VE tarihi geçmiş)
final completedJobsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // myQuotesProvider'dan tüm teklifleri al
  final allQuotes = await ref.watch(myQuotesProvider.future);
  
  final now = DateTime.now();
  
  // Sadece "Kabul Edildi" VE iş tarihi geçmiş olanları filtrele
  return allQuotes.where((quote) {
    final status = quote['status']?.toString().toLowerCase() ?? '';
    final isAccepted = status.contains('kabul');
    
    // İş başlangıç tarihini parse et (format: dd.MM.yyyy)
    final jobStartDateStr = quote['jobStartDate']?.toString() ?? '';
    if (jobStartDateStr.isEmpty || !isAccepted) return false;
    
    try {
      // Tarihi parse et (dd.MM.yyyy formatında)
      final parts = jobStartDateStr.split('.');
      if (parts.length != 3) return false;
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final jobDate = DateTime(year, month, day);
      
      // İş tarihi bugünden önce mi?
      return jobDate.isBefore(DateTime(now.year, now.month, now.day));
    } catch (e) {
      print('❌ Tarih parse hatası: $e');
      return false;
    }
  }).toList();
});

class CompletedJobsScreen extends ConsumerWidget {
  const CompletedJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(completedJobsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geçmiş İşlerim', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFFFAB00),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: jobsAsync.when(
        data: (jobs) {
          if (jobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Henüz tamamlanmış işiniz yok',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Kabul edilen teklifleriniz burada görünecek',
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
              ref.invalidate(completedJobsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return _CompletedJobCard(job: job);
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
                onPressed: () => ref.invalidate(completedJobsProvider),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletedJobCard extends StatelessWidget {
  final Map<String, dynamic> job;

  const _CompletedJobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final jobType = job['jobType'] ?? 'Belirtilmemiş';
    final city = job['city'] ?? '';
    final district = job['district'] ?? '';
    final craneName = job['craneName'] ?? 'Belirtilmemiş';
    final firmName = job['firmName'] ?? 'Belirtilmemiş';
    final jobStartDate = job['jobStartDate'] ?? '';
    final duration = job['duration'] ?? '';
    final description = job['jobDescription'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık ve Onay Badge
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
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        'Tamamlandı',
                        style: TextStyle(
                          color: Colors.green,
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.construction, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Vinç', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(
                              craneName,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.business, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Firma', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(
                              firmName,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tarih Bilgileri
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('İş Tarihi', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(jobStartDate, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Süre', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(duration, style: const TextStyle(fontWeight: FontWeight.w500)),
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
