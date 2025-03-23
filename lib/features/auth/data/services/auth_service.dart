import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:9000';
  String? _accessToken;

  String? get accessToken => _accessToken;

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  bool _isValidPhoneNumber(String phone) {
    // Basic phone number validation (10-15 digits)
    return RegExp(r'^\d{10,15}$').hasMatch(phone);
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/sign-in'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['accessToken'];
        return data;
      } else {
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
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
      throw Exception('Invalid email format');
    }

    // Validate phone number
    if (!_isValidPhoneNumber(phone)) {
      throw Exception('Invalid phone number format');
    }

    // Validate password match
    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/sign-up'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to sign up: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  void signOut() {
    _accessToken = null;
  }
} 