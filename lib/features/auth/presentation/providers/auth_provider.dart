import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  AuthProvider(this._authRepository);

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  String? get accessToken => _authRepository.accessToken;

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authRepository.signIn(email, password);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e is Failure ? e.message : e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authRepository.signUp(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e is Failure ? e.message : e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void signOut() {
    _authRepository.signOut();
    _isAuthenticated = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<String?> sendVerificationSms(String phone) async {
    try {
      await _authRepository.sendVerificationSms(phone);
      return null;
    } catch (e) {
      if (e is Failure) return e.message;
      return 'Failed to send verification SMS: $e';
    }
  }

  Future<String?> verifySmsCode(String phone, String code) async {
    try {
      final verified = await _authRepository.verifySmsCode(phone, code);
      if (!verified) {
        return 'Invalid verification code';
      }
      return null;
    } catch (e) {
      if (e is Failure) return e.message;
      return 'Failed to verify SMS code: $e';
    }
  }
} 