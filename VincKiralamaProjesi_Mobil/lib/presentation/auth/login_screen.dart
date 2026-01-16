import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vinc_kiralama/presentation/auth/auth_controller.dart';
import 'package:vinc_kiralama/domain/entities/user.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Specific for Firm
  final TextEditingController _firmKeyController = TextEditingController();

  bool _isRegisterMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Defer reading query params until build or post-frame, 
    // but initState is fine if we don't depend on context for inherited widgets immediately for logic
    // Actually using GoRouterState in build is better.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String? tab = GoRouterState.of(context).uri.queryParameters['tab'];
    if (tab == 'firm') _tabController.animateTo(1);
    if (tab == 'admin') _tabController.animateTo(2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firmKeyController.dispose();
    super.dispose();
  }

  void _submit() {
    print("Submit düğmesine basıldı");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('İşlem yapılıyor, lütfen bekleyin...'), duration: Duration(seconds: 1)),
    );
    final authNotifier = ref.read(authStateProvider.notifier);
    final email = _emailController.text.trim();
    print("Email: $email");
    print("Tab Index: ${_tabController.index}");
    
    if (_tabController.index == 0) { // Customer
      final password = _passwordController.text;
      print("Müşteri girişi deneniyor...");
      authNotifier.loginCustomer(email, password);
    } else if (_tabController.index == 1) { // Firm
      final key = _firmKeyController.text.trim();
      print("Firma girişi deneniyor, anahtar: $key");
      authNotifier.loginFirm(email, key);
    } else { // Admin
      final password = _passwordController.text;
      print("Admin girişi deneniyor...");
      authNotifier.loginAdmin(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch state for error/loading
    final authState = ref.watch(authStateProvider);

    // Show error dialog listener
    ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
      if (next.hasError) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Hata', style: TextStyle(color: Colors.red)),
            content: Text(next.error.toString()),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Tamam')),
            ],
          ),
        );
      }
      if (next.hasValue && next.value != null) {
         print("✅ Giriş Başarılı! Kullanıcı: ${next.value?.email}");
         // Router otomatik yönlendirecek
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap / Kayıt Ol'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'Müşteri'),
            Tab(text: 'Firma'),
            Tab(text: 'Admin'),
          ],
        ),
      ),
      body: authState.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (authState.hasError)
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.red.shade100,
                      child: Text('Hata: ${authState.error}', style: const TextStyle(color: Colors.red)),
                    ),
                  const SizedBox(height: 20),
                  
                  // Content changes based on Tab... but TabBarView is better for separate structures.
                  // However, to keep it simple and sharing controllers (which is risky if fields differ),
                  // verify active tab.
                  
                  SizedBox(
                    height: 400, // Fixed height for simplicity in this example
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildCustomerForm(),
                        _buildFirmForm(),
                        _buildAdminForm(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildCustomerForm() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Şifre', prefixIcon: Icon(Icons.lock)),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Giriş Yap'),
        ),
        TextButton(
          onPressed: () {
            // Kayıt ekranına yönlendir
            context.push('/customer-register');
          },
          child: const Text('Hesabınız yok mu? Kayıt Olun'),
        ),
      ],
    );
  }

  Widget _buildFirmForm() {
    return Column(
      children: [
        const Text('Firma girişi için size gönderilen anahtarı kullanın.'),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Firma Email', prefixIcon: Icon(Icons.business)),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _firmKeyController,
          decoration: const InputDecoration(labelText: 'Firma Anahtarı (Key)', prefixIcon: Icon(Icons.vpn_key)),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Giriş Yap (Anahtar ile)'),
        ),
        TextButton(
          onPressed: () {
             // Logic to resend key
             // ref.read(firmProvider).resendKey(...)
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anahtar tekrar gönderildi (Simülasyon)')));
          },
          child: const Text('Anahtarı unuttum / Yeniden gönder'),
        ),
        TextButton(
          onPressed: () => context.push('/apply-firm'),
          child: const Text('Firma Başvurusu Yap'),
        ),
      ],
    );
  }

  Widget _buildAdminForm() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Admin Email', prefixIcon: Icon(Icons.admin_panel_settings)),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Şifre', prefixIcon: Icon(Icons.lock)),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Admin Giriş'),
        ),
      ],
    );
  }
}
