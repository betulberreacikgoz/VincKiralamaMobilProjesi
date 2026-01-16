import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/presentation/auth/auth_controller.dart';
import 'package:vinc_kiralama/presentation/customer/quote_request_screen.dart';
import 'package:vinc_kiralama/presentation/customer/my_quotes_screen.dart';
import 'package:vinc_kiralama/presentation/customer/completed_jobs_screen.dart';
import 'package:vinc_kiralama/presentation/customer/active_jobs_screen.dart';

class CustomerDashboardScreen extends ConsumerWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Müşteri Paneli', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFFFAB00), // Sarı
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Hoşgeldin Kartı
              Card(
                color: Colors.amber.shade50,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFFFAB00),
                            radius: 30,
                            child: Text(
                              (user?.email != null && user!.email.isNotEmpty) 
                                  ? user.email.substring(0, 1).toUpperCase() 
                                  : 'M',
                              style: const TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hoş Geldiniz!',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  user?.email ?? '',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Teklif Al Butonu
              _ActionCard(
                title: 'Vinç Kirala',
                subtitle: 'İhtiyacınıza uygun vinç bulun ve teklif alın',
                icon: Icons.construction,
                color: const Color(0xFFFFAB00), // Sarı
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuoteRequestScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Tekliflerim
              _ActionCard(
                title: 'Tekliflerim',
                subtitle: 'Gönderdiğiniz teklif isteklerini görüntüleyin',
                icon: Icons.assignment,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyQuotesScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Aktif İşler
              _ActionCard(
                title: 'Aktif İşlerim',
                subtitle: 'Devam eden ve yaklaşan işleriniz',
                icon: Icons.work,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ActiveJobsScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Geçmiş İşler
              _ActionCard(
                title: 'Geçmiş İşlerim',
                subtitle: 'Tamamlanan kiralama işlemleriniz',
                icon: Icons.history,
                color: Colors.grey.shade800, // Siyah
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CompletedJobsScreen()),
                  );
                },
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

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
