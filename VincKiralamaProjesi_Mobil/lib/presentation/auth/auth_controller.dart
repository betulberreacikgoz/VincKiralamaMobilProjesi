import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/domain/entities/user.dart';
import 'package:vinc_kiralama/data/repositories/auth_repository_impl.dart';
import 'package:vinc_kiralama/domain/repositories/auth_repository.dart';

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(repo);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AsyncValue.loading()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = await _repo.getCurrentUser();
      if (user != null) {
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginAdmin(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.loginAdmin(email, password));
  }

  Future<void> loginCustomer(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.loginCustomer(email, password));
  }
  
  Future<void> registerCustomer(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.registerCustomer(email, password));
  }

  Future<void> loginFirm(String email, String key) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.loginFirm(email, key));
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(null);
  }
}
