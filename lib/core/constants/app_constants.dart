class AppConstants {
  static const String appName = 'User App';
  static const String baseUrl = 'http://localhost:9000';
  
  // API Endpoints
  static const String signInEndpoint = '/auth/sign-in';
  static const String signUpEndpoint = '/user/sign-up';
  static const String signOutEndpoint = '/auth/sign-out';
  static const String sendSmsEndpoint = '/auth/sms/send';
  static const String verifySmsEndpoint = '/auth/sms/verify';
  static const String termsEndpoint = '/user/public/terms';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  
  // Validation
  static const int minPasswordLength = 6;
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^\d{10,15}$';
} 