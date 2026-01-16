import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/data/repositories/crane_repository.dart';
import 'package:vinc_kiralama/domain/entities/crane.dart';
import 'package:vinc_kiralama/presentation/auth/auth_controller.dart';
import 'package:vinc_kiralama/presentation/firm/crane_add_edit_screen.dart';
import 'package:vinc_kiralama/presentation/firm/offers_tab.dart';
import 'package:vinc_kiralama/presentation/firm/firm_active_jobs_tab.dart';
import 'package:vinc_kiralama/presentation/firm/firm_completed_jobs_tab.dart';

final myCranesProvider = FutureProvider<List<Crane>>((ref) async {
  return ref.watch(craneRepositoryProvider).getMyCranes();
});

class FirmDashboardScreen extends ConsumerWidget {
  const FirmDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4, // 4 sekme
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Firma Paneli'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.construction), text: 'Vinçlerim'),
              Tab(icon: Icon(Icons.assignment), text: 'Gelen Teklifler'),
              Tab(icon: Icon(Icons.work), text: 'Aktif İşler'),
              Tab(icon: Icon(Icons.history), text: 'Geçmiş İşler'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => ref.read(authStateProvider.notifier).logout(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
             Navigator.of(context).push(
               MaterialPageRoute(builder: (context) => const CraneAddEditScreen()),
             );
          },
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            // 1. Sekme: Vinçlerim
            const _MyCranesTab(),
            
            // 2. Sekme: Gelen Teklifler
            const OffersTab(),
            
            // 3. Sekme: Aktif İşler
            const FirmActiveJobsTab(),
            
            // 4. Sekme: Geçmiş İşler
            const FirmCompletedJobsTab(),
          ],
        ),
      ),
    );
  }
}

class _MyCranesTab extends ConsumerWidget {
  const _MyCranesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myCranesAsync = ref.watch(myCranesProvider);

    return myCranesAsync.when(
      data: (cranes) => cranes.isEmpty 
        ? const Center(child: Text('Henüz hiç vinciniz yok. + butonuna basarak ekleyin.'))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cranes.length,
            itemBuilder: (context, index) {
              final crane = cranes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.amber, 
                    child: Icon(Icons.construction, color: Colors.white)
                  ),
                  title: Text(crane.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${crane.capacityTon} Ton - ${crane.city}\n${crane.description}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue), 
                        onPressed: () {
                           Navigator.of(context).push(
                             MaterialPageRoute(builder: (context) => CraneAddEditScreen(crane: crane)),
                           );
                        }
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red), 
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text('Sil?'),
                              content: const Text('Bu vinci silmek istediğinize emin misiniz?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('İptal')),
                                TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Sil', style: TextStyle(color: Colors.red))),
                              ],
                            )
                          );
                          
                          if (confirm == true) {
                            try {
                              await ref.read(craneRepositoryProvider).deleteCrane(crane.id);
                              ref.invalidate(myCranesProvider); // Listeyi yenile
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
                            }
                          }
                        }
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
    );
  }
}

class _OffersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock Data: Müşteriden gelen teklif/iş talebi simülasyonu
    final offers = [
      {
        'customerName': 'Ahmet Yılmaz',
        'jobTitle': 'İnşaat Sahası Yük İndirme',
        'location': 'Pendik, İstanbul',
        'date': '10.05.2024',
        'details': '5. kata 2 tonluk klima ünitesi çıkarılacak.',
        'matchedCrane': 'Hidrokon 30 Ton'
      },
      {
        'customerName': 'ABC Lojistik',
        'jobTitle': 'Konteyner Taşıma',
        'location': 'Gebze, Kocaeli',
        'date': '12.05.2024',
        'details': 'Limandan depoya 2 adet konteyner taşınacak.',
        'matchedCrane': 'Liebherr 50 Ton'
      }
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(offer['jobTitle']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Chip(label: Text("Yeni", style: TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: Colors.redAccent)
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(offer['customerName']!),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(offer['location']!),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("📋 İş Detayı:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                      Text(offer['details']!),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text("Eşleşen Vinciniz: ${offer['matchedCrane']}", style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(onPressed: () {}, child: const Text("Reddet")),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teklif verildi! Müşteriye bildirim gitti.")));
                      },
                      child: const Text("Fiyat Teklifi Ver")
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
