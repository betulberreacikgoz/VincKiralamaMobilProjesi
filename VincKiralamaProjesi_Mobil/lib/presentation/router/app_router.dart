import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/presentation/auth/auth_controller.dart';
import 'package:vinc_kiralama/presentation/auth/login_screen.dart';
import 'package:vinc_kiralama/domain/entities/user.dart';
import 'package:vinc_kiralama/presentation/home/welcome_screen.dart';
import 'package:vinc_kiralama/presentation/firm/firm_dashboard_screen.dart';
import 'package:vinc_kiralama/presentation/admin/admin_dashboard_screen.dart';
import 'package:vinc_kiralama/presentation/customer/customer_dashboard_screen.dart';
import 'package:vinc_kiralama/presentation/customer/customer_register_screen.dart';
import 'package:vinc_kiralama/presentation/firm/firm_application_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      
      final isLoggedIn = authState.asData?.value != null;
      final user = authState.asData?.value;
      final role = user?.role;
      final path = state.uri.toString();
      
      print("🔀 Router Redirect Check:");
      print("   Path: $path");
      print("   LoggedIn: $isLoggedIn");
      print("   Role: $role");

      final isLoggingIn = path.startsWith('/login') || path == '/apply-firm' || path == '/customer-register';

      // 1. Giriş yapılmamışsa ve korumalı bir sayfadaysa -> Login'e at
      if (!isLoggedIn) {
        // Welcome (/) ve Login (/login) herkese açık
        if (path != '/' && !isLoggingIn) {
           return '/';
        }
        return null;
      }

      // 2. Giriş yapıldıysa -> İlgili dashboard'a yönlendir
      if (isLoggedIn) {
        // Zaten dashboarddaysa döngüye girme
        if (role == 'Admin' && !path.startsWith('/admin')) return '/admin';
        if (role == 'Firma' && !path.startsWith('/firm')) return '/firm';
        if (role == 'Musteri' && !path.startsWith('/customer')) return '/customer';
        
        // Backend İngilizce dönüyorsa diye fallback ekleyelim
        if (role == 'Firm' && !path.startsWith('/firm')) return '/firm';
        if (role == 'Customer' && !path.startsWith('/customer')) return '/customer';
        
        // Giriş yapılmış ama hala Login ekranındaysak ve yukarıdaki role uymadıysa
        // Demek ki rol tanınmadı veya başka bir sorun var. Yine de Login'den çıkaralım.
        if (isLoggingIn) {
           print("⚠️ Rol tanınamadı veya eşleşmedi ($role), varsayılan olarak Müşteri ekranına gidiliyor.");
           return '/customer'; 
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/customer-register',
        builder: (context, state) => const CustomerRegisterScreen(),
      ),
       GoRoute(
        path: '/apply-firm',
        builder: (context, state) => const FirmApplicationScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/firm',
        builder: (context, state) => const FirmDashboardScreen(),
      ),
      GoRoute(
        path: '/customer',
        builder: (context, state) => const CustomerDashboardScreen(),
      ),
    ],
  );
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<User?>>(
      authStateProvider,
      (_, __) => notifyListeners(),
    );
  }
}
