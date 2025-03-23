import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  String? get accessToken => _authService.accessToken;

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      return await _authService.signIn(email, password);
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure(message: 'Failed to sign in: $e');
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      return UserModel.fromJson(response);
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure(message: 'Failed to sign up: $e');
    }
  }

  void signOut() {
    _authService.signOut();
  }

  Future<void> sendVerificationSms(String phone) async {
    try {
      await _authService.sendVerificationSms(phone);
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure(message: 'Failed to send verification SMS: $e');
    }
  }

  Future<bool> verifySmsCode(String phone, String code) async {
    try {
      return await _authService.verifySmsCode(phone, code);
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure(message: 'Failed to verify SMS code: $e');
    }
  }
} 