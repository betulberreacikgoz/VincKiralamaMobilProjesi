import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/core/constants/app_constants.dart';
import 'package:vinc_kiralama/core/storage/storage_service.dart';
import 'package:vinc_kiralama/data/datasources/auth_remote_data_source.dart';
import 'package:vinc_kiralama/domain/entities/user.dart';
import 'package:vinc_kiralama/domain/repositories/auth_repository.dart';
import 'dart:convert';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthRepositoryImpl(remoteDataSource, storageService);
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final StorageService _storage;

  AuthRepositoryImpl(this._dataSource, this._storage);

  Future<void> _saveSession(User user) async {
    if (user.token != null) {
      await _storage.write(key: AppConstants.authTokenKey, value: user.token!);
    }
    await _storage.write(key: AppConstants.userRoleKey, value: user.role);
    // Optionally save full user as json
    // await _storage.write(key: 'user_data', value: jsonEncode(user.toJson()));
  }

  @override
  Future<User> loginAdmin(String email, String password) async {
    final user = await _dataSource.loginAdmin(email, password);
    await _saveSession(user);
    return user;
  }

  @override
  Future<User> loginCustomer(String email, String password) async {
    final user = await _dataSource.loginCustomer(email, password);
    await _saveSession(user);
    return user;
  }

  @override
  Future<User> registerCustomer(String email, String password) async {
    // registerCustomer artık Map döndürüyor, User değil
    // Bu metodu kullanmıyoruz, direkt AuthRemoteDataSource'dan çağırıyoruz
    throw UnimplementedError('Use AuthRemoteDataSource.registerCustomer directly');
  }

  @override
  Future<User> loginFirm(String email, String firmKey) async {
    final user = await _dataSource.loginFirm(email, firmKey);
    await _saveSession(user);
    return user;
  }

  @override
  Future<Map<String, dynamic>> registerFirm(Map<String, dynamic> firmData) async {
    return await _dataSource.registerFirm(firmData);
  }

  @override
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  @override
  Future<User?> getCurrentUser() async {
    // Basic check if token exists. Realistically, we might want to fetch /me logic
    // or parse the saved user data. For now, checking token presence + generic role.
    final token = await _storage.read(key: AppConstants.authTokenKey);
    final role = await _storage.read(key: AppConstants.userRoleKey);

    if (token != null && role != null) {
      // Return a partial user logic just to satisfy session existence
      return User(id: 'cached', email: '', role: role, token: token); 
    }
    return null;
  }
}
