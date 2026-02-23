class AppError implements Exception {
  final String message;
  final String? code;
  const AppError(this.message, {this.code});
  @override
  String toString() => 'AppError($code): $message';
}

class AuthError extends AppError {
  const AuthError(super.message, {super.code});
}

class NetworkError extends AppError {
  const NetworkError(super.message, {super.code});
}

class QuotaExceededError extends AppError {
  const QuotaExceededError(super.message, {super.code});
}

class NotFoundError extends AppError {
  const NotFoundError(super.message, {super.code});
}
