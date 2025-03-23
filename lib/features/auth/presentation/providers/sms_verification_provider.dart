import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

class SmsVerificationProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoading = false;
  String? _error;
  bool _isVerified = false;
  String? _phone;
  int _remainingTime = 0;
  Timer? _timer;

  SmsVerificationProvider(this._authRepository);

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isVerified => _isVerified;
  String? get phone => _phone;
  int get remainingTime => _remainingTime;

  void startTimer() {
    _remainingTime = 180; // 3분
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<bool> sendVerificationSms(String phone) async {
    try {
      _isLoading = true;
      _error = null;
      _phone = phone;
      _isVerified = false;
      notifyListeners();

      await _authRepository.sendVerificationSms(phone);
      startTimer();
      
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

  Future<bool> verifyCode(String code) async {
    if (_phone == null) return false;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final verified = await _authRepository.verifySmsCode(_phone!, code);
      _isVerified = verified;
      
      _isLoading = false;
      notifyListeners();
      return verified;
    } catch (e) {
      _error = e is Failure ? e.message : e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 