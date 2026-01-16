import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/data/repositories/crane_repository.dart';
import 'package:vinc_kiralama/domain/entities/crane.dart';
import 'package:vinc_kiralama/domain/entities/category.dart';
import 'package:vinc_kiralama/presentation/auth/auth_controller.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return ref.watch(craneRepositoryProvider).getCategories();
});

final allCranesProvider = FutureProvider<List<Crane>>((ref) async {
  return ref.watch(craneRepositoryProvider).getAllCranes();
});

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final cranesAsync = ref.watch(allCranesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VincKiralama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Vinç ara (şehir, kapasite, kategori)...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
            ),

            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text('Kategoriler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            
            SizedBox(
              height: 100,
              child: categoriesAsync.when(
                data: (categories) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.construction, color: Colors.amber), // Placeholder icon
                          const SizedBox(height: 8),
                          Text(cat.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Hata: $e')),
              ),
            ),

            const SizedBox(height: 24),
            // Featured Cranes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text('Popüler Vinçler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
             const SizedBox(height: 10),

            cranesAsync.when(
              data: (cranes) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: cranes.length,
                itemBuilder: (context, index) {
                  final crane = cranes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: const Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(crane.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text('${crane.dailyPrice} ₺/gün', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('${crane.city} • ${crane.capacityTon} Ton'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              // Go to Detail
                            },
                            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 36)),
                            child: const Text('İncele'),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Yüklenemedi: $e')),
            ),
          ],
        ),
      ),
    );
  }
}
