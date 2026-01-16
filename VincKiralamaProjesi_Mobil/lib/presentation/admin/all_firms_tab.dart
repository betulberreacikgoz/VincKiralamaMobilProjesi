import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/core/network/dio_client.dart';

// Tüm firmaları getiren provider (Aktif + Devre Dışı)
final allFirmsProvider = FutureProvider.autoDispose((ref) async {
  final dio = ref.read(dioClientProvider).dio;
  final response = await dio.get('/api/admin/firms');
  return List<Map<String, dynamic>>.from(response.data);
});

class AllFirmsTab extends ConsumerWidget {
  const AllFirmsTab({super.key});

  Future<void> _toggleFirmStatus(BuildContext context, WidgetRef ref, int firmId, bool currentStatus) async {
    try {
      final dio = ref.read(dioClientProvider).dio;
      final endpoint = currentStatus ? '/api/admin/firms/$firmId/disable' : '/api/admin/firms/$firmId/enable';
      
      await dio.post(endpoint);
      
      // Provider'ı yenile
      ref.invalidate(allFirmsProvider);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(currentStatus ? 'Firma devre dışı bırakıldı' : 'Firma aktif edildi'),
            backgroundColor: currentStatus ? Colors.orange : Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firmsAsync = ref.watch(allFirmsProvider);

    return firmsAsync.when(
      data: (firms) {
        if (firms.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Henüz onaylanmış firma yok', style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(allFirmsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: firms.length,
            itemBuilder: (context, index) {
              final firm = firms[index];
              return _FirmCard(
                firm: firm,
                onToggleStatus: () => _toggleFirmStatus(
                  context,
                  ref,
                  firm['id'],
                  firm['isApproved'] ?? true,
                ),
              );
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
              onPressed: () => ref.invalidate(allFirmsProvider),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FirmCard extends StatelessWidget {
  final Map<String, dynamic> firm;
  final VoidCallback onToggleStatus;

  const _FirmCard({required this.firm, required this.onToggleStatus});

  @override
  Widget build(BuildContext context) {
    final name = firm['name'] ?? 'İsimsiz Firma';
    final email = firm['email'] ?? '';
    final phone = firm['phone'] ?? '';
    final address = firm['address'] ?? '';
    final apiKey = firm['apiKey'] ?? '';
    final craneCount = firm['craneCount'] ?? 0;
    final offerCount = firm['offerCount'] ?? 0;
    final isApproved = firm['isApproved'] ?? true;

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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isApproved ? Icons.check_circle : Icons.cancel,
                            size: 16,
                            color: isApproved ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isApproved ? 'Aktif' : 'Devre Dışı',
                            style: TextStyle(
                              color: isApproved ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isApproved ? Icons.block : Icons.check_circle_outline,
                    color: isApproved ? Colors.red : Colors.green,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(isApproved ? 'Firmayı Devre Dışı Bırak' : 'Firmayı Aktif Et'),
                        content: Text(
                          isApproved
                              ? 'Bu firmayı devre dışı bırakmak istediğinize emin misiniz?'
                              : 'Bu firmayı tekrar aktif etmek istediğinize emin misiniz?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('İptal'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              onToggleStatus();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isApproved ? Colors.red : Colors.green,
                            ),
                            child: Text(isApproved ? 'Devre Dışı Bırak' : 'Aktif Et'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // İletişim Bilgileri
            if (email.isNotEmpty) _InfoRow(icon: Icons.email, text: email),
            if (phone.isNotEmpty) _InfoRow(icon: Icons.phone, text: phone),
            if (address.isNotEmpty) _InfoRow(icon: Icons.location_on, text: address),
            
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // İstatistikler ve API Key
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.construction, color: Colors.blue, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          '$craneCount',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Text('Vinç', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.assignment, color: Colors.orange, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          '$offerCount',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Text('Teklif', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            if (apiKey.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.key, size: 16, color: Colors.brown),
                    const SizedBox(width: 8),
                    const Text('API Key:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        apiKey,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
