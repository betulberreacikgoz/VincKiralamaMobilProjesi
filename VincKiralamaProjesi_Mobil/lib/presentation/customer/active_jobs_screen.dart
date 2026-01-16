import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/presentation/customer/my_quotes_screen.dart';

// Aktif işleri getiren provider (Kabul edilmiş VE tarihi henüz gelmemiş/bugün)
final activeJobsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final allQuotes = await ref.watch(myQuotesProvider.future);
  
  final now = DateTime.now();
  
  // Sadece "Kabul Edildi" VE iş tarihi bugün veya gelecekte olanları filtrele
  return allQuotes.where((quote) {
    final status = quote['status']?.toString().toLowerCase() ?? '';
    final isAccepted = status.contains('kabul');
    
    final jobStartDateStr = quote['jobStartDate']?.toString() ?? '';
    if (jobStartDateStr.isEmpty || !isAccepted) return false;
    
    try {
      final parts = jobStartDateStr.split('.');
      if (parts.length != 3) return false;
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final jobDate = DateTime(year, month, day);
      
      // İş tarihi bugün veya gelecekte mi?
      return !jobDate.isBefore(DateTime(now.year, now.month, now.day));
    } catch (e) {
      print('❌ Tarih parse hatası: $e');
      return false;
    }
  }).toList();
});

class ActiveJobsScreen extends ConsumerWidget {
  const ActiveJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(activeJobsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktif İşlerim', style: TextStyle(color: Colors.black)),
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
                  Icon(Icons.work_outline, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Henüz aktif işiniz yok',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Kabul edilen ve devam eden işleriniz burada görünecek',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
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
              ref.invalidate(activeJobsProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return _ActiveJobCard(job: job);
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
                onPressed: () => ref.invalidate(activeJobsProvider),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveJobCard extends StatelessWidget {
  final Map<String, dynamic> job;

  const _ActiveJobCard({required this.job});

  // İşin durumunu hesapla
  String _getJobStatus(String jobStartDateStr) {
    try {
      final parts = jobStartDateStr.split('.');
      if (parts.length != 3) return 'Planlandı';
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final jobDate = DateTime(year, month, day);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      if (jobDate.isAtSameMomentAs(today)) {
        return 'Bugün Başlıyor';
      } else if (jobDate.isAfter(today)) {
        final daysUntil = jobDate.difference(today).inDays;
        return '$daysUntil gün sonra';
      } else {
        return 'Devam Ediyor';
      }
    } catch (e) {
      return 'Planlandı';
    }
  }

  Color _getStatusColor(String status) {
    if (status == 'Bugün Başlıyor') return Colors.orange;
    if (status == 'Devam Ediyor') return Colors.blue;
    return Colors.purple;
  }

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
    
    final status = _getJobStatus(jobStartDate);
    final statusColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık ve Durum Badge
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
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
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
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.construction, size: 16, color: Colors.blue),
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
                      const Icon(Icons.business, size: 16, color: Colors.blue),
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
                    const Text('Başlangıç', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
