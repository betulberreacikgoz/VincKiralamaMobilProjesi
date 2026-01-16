import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vinc_kiralama/data/repositories/crane_repository.dart';
import 'package:vinc_kiralama/domain/entities/crane.dart';
import 'package:vinc_kiralama/domain/entities/category.dart';
import 'package:vinc_kiralama/presentation/auth/auth_controller.dart'; // AuthStateProvider için
import 'package:vinc_kiralama/presentation/firm/firm_dashboard_screen.dart'; // For refreshing myCranes

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return ref.read(craneRepositoryProvider).getCategories();
});

class CraneAddEditScreen extends ConsumerStatefulWidget {
  final Crane? crane;

  const CraneAddEditScreen({super.key, this.crane});

  @override
  ConsumerState<CraneAddEditScreen> createState() => _CraneAddEditScreenState();
}

class _CraneAddEditScreenState extends ConsumerState<CraneAddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _tonController;
  late TextEditingController _priceController;
  late TextEditingController _cityController;
  
  String? _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.crane?.title ?? '');
    _descController = TextEditingController(text: widget.crane?.description ?? '');
    _tonController = TextEditingController(text: widget.crane?.capacityTon.toString() ?? '');
    _priceController = TextEditingController(text: widget.crane?.dailyPrice.toString() ?? '');
    _cityController = TextEditingController(text: widget.crane?.city ?? '');
    _selectedCategory = widget.crane?.categoryName;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tonController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen kategori seçin')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Giriş yapmış kullanıcının ID'sini alıyoruz
      final userState = ref.read(authStateProvider);
      final currentUserId = userState.value?.id ?? '0';
      final firmIdInt = int.tryParse(currentUserId) ?? 0;

      final newCrane = Crane(
        id: widget.crane?.id ?? 0, // 0 for new
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        capacityTon: double.tryParse(_tonController.text) ?? 0,
        dailyPrice: double.tryParse(_priceController.text) ?? 0,
        city: _cityController.text.trim(),
        categoryName: _selectedCategory!,
        firmId: firmIdInt, // <-- ARTIK GİRİŞ YAPAN ID
        firmName: '', // Backend will handle
        imageUrls: [],
      );

      final repo = ref.read(craneRepositoryProvider);
      
      if (widget.crane == null) {
        await repo.addCrane(newCrane);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vinç eklendi')));
      } else {
        await repo.updateCrane(newCrane);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vinç güncellendi')));
      }

      // Refresh list
      ref.invalidate(myCranesProvider);
      if (mounted) context.pop();

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.crane == null ? 'Yeni Vinç Ekle' : 'Vinç Düzenle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Başlık (Örn: Hiyap 30 Ton)'),
                validator: (v) => v!.isEmpty ? 'Gerekli' : null,
              ),
              const SizedBox(height: 16),
              
              // Kategori Seçimi
              categoriesAsync.when(
                data: (categories) {
                  // _selectedCategory listede var mı kontrol et, yoksa null yap
                  if (_selectedCategory != null && 
                      !categories.any((c) => c.name == _selectedCategory)) {
                    _selectedCategory = null; 
                  }
                  
                  return DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: categories.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    validator: (v) => v == null ? 'Lütfen bir kategori seçin' : null,
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Kategoriler yüklenemedi: $e'),
              ),
              
              const SizedBox(height: 16),
              Row(
                children: [
                   Expanded(
                     child: TextFormField(
                      controller: _tonController,
                      decoration: const InputDecoration(labelText: 'Kapasite (Ton)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Gerekli' : null,
                                     ),
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                     child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Günlük Fiyat (TL)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Gerekli' : null,
                                     ),
                   ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Şehir'),
                validator: (v) => v!.isEmpty ? 'Gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Açıklama / Özellikler'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _save, 
                      child: Text(widget.crane == null ? 'KAYDET' : 'GÜNCELLE')
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
