import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_client.dart';
import 'package:email_validator/email_validator.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  String? get accessToken => _apiClient.accessToken;

  bool _isValidPhoneNumber(String phone) {
    return RegExp(AppConstants.phonePattern).hasMatch(phone);
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await _apiClient.post(
        AppConstants.signInEndpoint,
        {
          'email': email,
          'password': password,
        },
      );
      
      final data = response['data'];
      if (data == null) {
        throw AuthFailure(message: 'Data not found in response');
      }

      final token = data['accessToken'];
      if (token == null) {
        throw AuthFailure(message: 'Access token not found in response');
      }
      
      _apiClient.setToken(token);
      return response;
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure(message: 'Failed to sign in: $e');
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    // Validate email format
    if (!EmailValidator.validate(email)) {
      throw ValidationFailure(message: 'Invalid email format');
    }

    // Validate phone number
    if (!_isValidPhoneNumber(phone)) {
      throw ValidationFailure(message: 'Invalid phone number format');
    }

    // Validate password match
    if (password != confirmPassword) {
      throw ValidationFailure(message: 'Passwords do not match');
    }

    try {
      final response = await _apiClient.post(
        AppConstants.signUpEndpoint,
        {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
        },
      );
      
      if (response['data'] == null) {
        throw AuthFailure(message: 'Invalid server response: missing data');
      }
      print('Sign up server response: $response');

      return response['data'];
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure(message: 'Failed to sign up: $e');
    }
  }

  void signOut() {
    _apiClient.clearToken();
  }

  Future<void> sendVerificationSms(String phone) async {
    try {
      await _apiClient.post(
        AppConstants.sendSmsEndpoint,
        {'phone': phone},
      );
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure(message: 'Failed to send verification SMS: $e');
    }
  }

  Future<bool> verifySmsCode(String phone, String code) async {
    try {
      final response = await _apiClient.post(
        AppConstants.verifySmsEndpoint,
        {
          'phone': phone,
          'code': code,
        },
      );
      
      return response['data'] as bool;
    } catch (e) {
      if (e is Failure) rethrow;
      throw AuthFailure(message: 'Failed to verify SMS code: $e');
    }
  }
} 