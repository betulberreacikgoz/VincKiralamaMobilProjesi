import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/data/datasources/auth_remote_data_source.dart';
import 'package:vinc_kiralama/presentation/auth/auth_controller.dart';
import 'package:vinc_kiralama/presentation/admin/all_firms_tab.dart';

// Firms Provider
final firmsProvider = FutureProvider.autoDispose((ref) async {
  return ref.watch(authRemoteDataSourceProvider).getAllFirms();
});

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firmsAsync = ref.watch(firmsProvider);

    return DefaultTabController(
      length: 2, // İki sekme: Başvurular ve Firmalar
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Paneli'),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.black, // Seçili tab siyah
            unselectedLabelColor: Colors.black54, // Seçili olmayan tab koyu gri
            tabs: [
              Tab(text: 'Gelen Başvurular', icon: Icon(Icons.notification_important)),
              Tab(text: 'Kayıtlı Firmalar', icon: Icon(Icons.verified_user)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.refresh(firmsProvider),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => ref.read(authStateProvider.notifier).logout(),
            ),
          ],
        ),
        body: firmsAsync.when(
          data: (firms) {
            // Listeyi İkiye Ayır
            final pendingFirms = firms.where((f) {
              final isApproved = (f['isApproved'] ?? f['IsApproved']) == true;
              return !isApproved;
            }).toList();

            final approvedFirms = firms.where((f) {
              final isApproved = (f['isApproved'] ?? f['IsApproved']) == true;
              return isApproved;
            }).toList();

            return TabBarView(
              children: [
                // 1. Sekme: Başvurular (Onay Bekleyenler)
                _buildFirmList(context, ref, pendingFirms, isPendingTab: true),
                
                // 2. Sekme: Tüm Firmalar (Yeni Widget)
                const AllFirmsTab(),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Hata: $err')),
        ),
      ),
    );
  }

  Widget _buildFirmList(BuildContext context, WidgetRef ref, List<dynamic> firms, {required bool isPendingTab}) {
    if (firms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isPendingTab ? Icons.inbox : Icons.business, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              isPendingTab ? "Bekleyen başvuru yok." : "Henüz kayıtlı firma yok.",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: firms.length,
      itemBuilder: (context, index) {
        final firm = firms[index];
        if (firm == null) return const SizedBox.shrink();

        final id = firm['id'] ?? firm['Id'] ?? 0;
        final name = firm['name'] ?? firm['Name'] ?? 'İsimsiz Firma';
        final email = firm['email'] ?? firm['Email'] ?? '';
        final phone = firm['phone'] ?? firm['Phone'] ?? firm['phoneNumber'] ?? 'Tel Yok';
        final apiKey = firm['firmKey'] ?? firm['FirmKey'];
        final city = firm['city'] ?? firm['City'] ?? 'Şehir Yok'; // Şehir bilgisini de ekleyelim

        return _buildApplicationCard(
          context,
          ref,
          firmId: id,
          firmName: name,
          email: email,
          phone: phone,
          city: city,
          isPending: isPendingTab,
          apiKey: apiKey,
        );
      },
    );
  }

  Widget _buildApplicationCard(BuildContext context, WidgetRef ref, {
    required int firmId, 
    required String firmName, 
    required String email, 
    required String phone, 
    required String city,
    required bool isPending, 
    String? apiKey
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Kısım: İsim ve Şehir
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: isPending ? Colors.orange.shade100 : Colors.blue.shade100,
                  foregroundColor: isPending ? Colors.orange : Colors.blue,
                  child: Icon(isPending ? Icons.person_add : Icons.business),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(firmName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(city, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
                if (isPending)
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                     decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
                     child: const Text("ONAY BEKLİYOR", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                   ),
              ],
            ),
            
            const Divider(height: 24),
            
            // Bilgiler
            _infoRow(Icons.email, email),
            const SizedBox(height: 8),
            _infoRow(Icons.phone, phone),

            const SizedBox(height: 16),

            // Aksiyon Butonları
            if (isPending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, 
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12)
                  ),
                  icon: const Icon(Icons.check_circle),
                  label: const Text("BAŞVURUYU ONAYLA"),
                  onPressed: () async {
                     try {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("İşleniyor...")));
                       await ref.read(authRemoteDataSourceProvider).approveFirm(firmId);
                       ref.invalidate(firmsProvider);
                       if (context.mounted) {
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Firma onaylandı ve mail gönderildi ✅")));
                       }
                     } catch (e) {
                        if (context.mounted) {
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e"), backgroundColor: Colors.red));
                       }
                     }
                  }, 
                ),
              ),
            
            if (!isPending)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Firma Anahtarı:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  SelectableText(
                    apiKey ?? "YOK", 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Courier', letterSpacing: 1),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
