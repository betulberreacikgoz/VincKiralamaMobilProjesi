import 'package:vinc_kiralama/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> loginAdmin(String email, String password);
  Future<User> loginCustomer(String email, String password);
  Future<User> registerCustomer(String email, String password);
  Future<User> loginFirm(String email, String firmKey);
  Future<Map<String, dynamic>> registerFirm(Map<String, dynamic> firmData);
  Future<void> logout();
  Future<User?> getCurrentUser();
}
