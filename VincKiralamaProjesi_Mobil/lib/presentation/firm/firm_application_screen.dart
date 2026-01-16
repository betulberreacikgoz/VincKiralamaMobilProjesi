import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vinc_kiralama/data/repositories/auth_repository_impl.dart';

class FirmApplicationScreen extends ConsumerStatefulWidget {
  const FirmApplicationScreen({super.key});

  @override
  ConsumerState<FirmApplicationScreen> createState() => _FirmApplicationScreenState();
}

class _FirmApplicationScreenState extends ConsumerState<FirmApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Fields based on requirements
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _taxNoController = TextEditingController();
  final _descController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final firmData = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'city': _cityController.text.trim(),
        'address': _addressController.text.trim(),
        'taxNo': _taxNoController.text.trim(),
        'description': _descController.text.trim(),
      };

      try {
        final result = await ref.read(authRepositoryProvider).registerFirm(firmData);
        
        if (!mounted) return;
        
        // Backend'den gelen 'Message' ve 'Id' değerlerini gösterelim
        // Backend'den gelen 'Message' ve 'Id' değerlerini gösterelim (Backend büyük/küçük harf duyarlı olabilir)
        final message = result['Message'] ?? result['message'] ?? 'Başvurunuz alındı.';
        final newId = result['Id'] ?? result['id'] ?? '?';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$message (Kayıt ID: $newId). Lütfen yönetici onayı ve e-posta kontrolü için bekleyiniz.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
        
        // Ana ekrana dön
        context.go('/');
        
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firma Başvurusu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Filo sahibi misiniz? Başvuru yapın, vinçlerinizi kiralayın.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Firma Adı (Zorunlu)'),
                validator: (v) => v == null || v.isEmpty ? 'Gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email (Zorunlu)'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || v.isEmpty ? 'Gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefon (Zorunlu)'),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Şehir (Zorunlu)'),
                validator: (v) => v == null || v.isEmpty ? 'Gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Adres'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _taxNoController,
                decoration: const InputDecoration(labelText: 'Vergi No'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Açıklama / Not'),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Başvuruyu Gönder'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
