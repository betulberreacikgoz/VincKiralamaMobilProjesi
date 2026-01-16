import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/data/repositories/offer_repository_impl.dart';

// Sadece beklemedeki teklifleri getir
final incomingOffersProvider = FutureProvider.autoDispose((ref) async {
  final allOffers = await ref.watch(offerRepositoryProvider).getIncomingOffers();
  // Sadece "Beklemede" olanları filtrele
  return allOffers.where((offer) => offer.status == "Beklemede").toList();
});

class OffersTab extends ConsumerWidget {
  const OffersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(incomingOffersProvider);

    return offersAsync.when(
      data: (offers) {
        if (offers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text("Henüz gelen teklif yok", style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: offers.length,
          itemBuilder: (context, index) {
            final offer = offers[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
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
                        _StatusChip(status: offer.status),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.construction, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(offer.craneName, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("${offer.startDate} - ${offer.endDate}"),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("📋 İş Detayları:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                          const SizedBox(height: 8),
                          
                          // İş Türü
                          _DetailRow(icon: Icons.work, label: "İş Türü", value: offer.jobType),
                          
                          // Konum
                          _DetailRow(
                            icon: Icons.location_on, 
                            label: "Konum", 
                            value: offer.district != null ? '${offer.city}, ${offer.district}' : offer.city
                          ),
                          
                          // Saha Tipi
                          if (offer.siteType != null)
                            _DetailRow(icon: Icons.business, label: "Saha Tipi", value: offer.siteType!),
                          
                          // Erişim
                          if (offer.accessType != null)
                            _DetailRow(icon: Icons.route, label: "Erişim", value: offer.accessType!),
                          
                          // Yükseklik
                          if (offer.heightMeters != null)
                            _DetailRow(icon: Icons.height, label: "Yükseklik", value: '${offer.heightMeters}m'),
                          
                          // Yük Ağırlığı
                          if (offer.loadWeightKg != null)
                            _DetailRow(icon: Icons.fitness_center, label: "Yük", value: '${offer.loadWeightKg!.toStringAsFixed(0)}kg'),
                          
                          // Açıklama
                          if (offer.description.isNotEmpty) ...[
                            const Divider(height: 16),
                            const Text("Açıklama:", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(offer.description, style: const TextStyle(fontSize: 12)),
                          ],
                        ],
                      ),
                    ),
                    if (offer.status == "Beklemede") ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.close, size: 16),
                              label: const Text("Reddet"),
                              onPressed: () async {
                                try {
                                  await ref.read(offerRepositoryProvider).rejectOffer(offer.id);
                                  ref.invalidate(incomingOffersProvider);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Teklif reddedildi")),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              icon: const Icon(Icons.check, size: 16),
                              label: const Text("Kabul Et"),
                              onPressed: () async {
                                try {
                                  await ref.read(offerRepositoryProvider).acceptOffer(offer.id);
                                  ref.invalidate(incomingOffersProvider);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Teklif kabul edildi! ✅")),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Hata: $err')),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    
    switch (status) {
      case "Kabul Edildi":
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case "Reddedildi":
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.orange;
        icon = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.brown),
          const SizedBox(width: 6),
          Text('$label:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
