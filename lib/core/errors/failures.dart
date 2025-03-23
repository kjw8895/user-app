abstract class Failure {
  final String message;
  final String? code;

  Failure({required this.message, this.code});
}

class ServerFailure extends Failure {
  ServerFailure({required String message, String? code}) : super(message: message, code: code);
}

class NetworkFailure extends Failure {
  NetworkFailure({required String message, String? code}) : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  ValidationFailure({required String message, String? code}) : super(message: message, code: code);
}

class AuthFailure extends Failure {
  AuthFailure({required String message, String? code}) : super(message: message, code: code);
} 