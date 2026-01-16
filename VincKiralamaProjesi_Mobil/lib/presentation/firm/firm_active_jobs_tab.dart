import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/data/repositories/offer_repository_impl.dart';
import 'package:vinc_kiralama/domain/entities/offer.dart';

// Aktif işleri getir (Kabul edilmiş + bugün veya gelecekte)
final activeOffersProvider = FutureProvider.autoDispose((ref) async {
  final allOffers = await ref.watch(offerRepositoryProvider).getIncomingOffers();
  
  final now = DateTime.now();
  
  return allOffers.where((offer) {
    // Sadece kabul edilmiş olanlar
    if (offer.status != "Kabul Edildi") return false;
    
    // Tarihi parse et
    try {
      final parts = offer.startDate.split('.');
      if (parts.length != 3) return false;
      
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final jobDate = DateTime(year, month, day);
      
      // Bugün veya gelecekte mi?
      return !jobDate.isBefore(DateTime(now.year, now.month, now.day));
    } catch (e) {
      return false;
    }
  }).toList();
});

class FirmActiveJobsTab extends ConsumerWidget {
  const FirmActiveJobsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(activeOffersProvider);

    return offersAsync.when(
      data: (offers) {
        if (offers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text("Henüz aktif iş yok", style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(activeOffersProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return _ActiveOfferCard(offer: offer);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Hata: $err')),
    );
  }
}

class _ActiveOfferCard extends StatelessWidget {
  final Offer offer;

  const _ActiveOfferCard({required this.offer});

  String _getJobStatus(String jobStartDateStr) {
    try {
      final parts = jobStartDateStr.split('.');
      if (parts.length != 3) return 'Devam Ediyor';
      
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
      return 'Devam Ediyor';
    }
  }

  Color _getStatusColor(String status) {
    if (status == 'Bugün Başlıyor') return Colors.orange;
    if (status == 'Devam Ediyor') return Colors.blue;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    final status = _getJobStatus(offer.startDate);
    final statusColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(offer.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(offer.customerEmail, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // İş Detayları
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(icon: Icons.work, label: "İş Türü", value: offer.jobType),
                  _DetailRow(icon: Icons.location_on, label: "Konum", value: offer.district != null ? '${offer.city}, ${offer.district}' : offer.city),
                  if (offer.siteType != null) _DetailRow(icon: Icons.business, label: "Saha", value: offer.siteType!),
                  _DetailRow(icon: Icons.calendar_today, label: "Başlangıç", value: offer.startDate),
                  _DetailRow(icon: Icons.timer, label: "Süre", value: offer.endDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.blue),
          const SizedBox(width: 6),
          Text('$label:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
