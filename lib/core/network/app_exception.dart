import 'package:dio/dio.dart';

enum AppExceptionType {
  business,
  unauthorized,
  network,
  timeout,
  cancel,
  server,
  data,
  unknown,
}

/// Normalized app-level exception so the UI does not need to know Dio details.
class AppException implements Exception {
  const AppException({
    required this.type,
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  final AppExceptionType type;
  final String message;
  final String? code;
  final Object? originalError;
  final StackTrace? stackTrace;

  bool get isUnauthorized => type == AppExceptionType.unauthorized;

  bool get isRetryable =>
      type == AppExceptionType.network ||
      type == AppExceptionType.timeout ||
      type == AppExceptionType.server;

  factory AppException.business({
    String? code,
    String? message,
  }) {
    final normalizedCode = code?.trim();
    return AppException(
      type: normalizedCode == '401' || normalizedCode == '403'
          ? AppExceptionType.unauthorized
          : AppExceptionType.business,
      code: normalizedCode,
      message: (message == null || message.trim().isEmpty)
          ? '请求失败，请稍后重试'
          : message.trim(),
    );
  }

  factory AppException.data(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    return AppException(
      type: AppExceptionType.data,
      message: message,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  factory AppException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(
          type: AppExceptionType.timeout,
          message: '网络请求超时，请稍后重试',
          originalError: error,
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        return AppException(
          type: AppExceptionType.network,
          message: '当前网络不可用，请检查后重试',
          originalError: error,
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.cancel:
        return AppException(
          type: AppExceptionType.cancel,
          message: '请求已取消',
          originalError: error,
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return AppException(
          type: statusCode == 401 || statusCode == 403
              ? AppExceptionType.unauthorized
              : AppExceptionType.server,
          code: statusCode?.toString(),
          message: _messageForStatus(statusCode),
          originalError: error,
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.unknown:
        return AppException.unknown(error, error.stackTrace);
    }
  }

  factory AppException.unknown(
    Object error, [
    StackTrace? stackTrace,
  ]) {
    return AppException(
      type: AppExceptionType.unknown,
      message: '发生未知错误，请稍后重试',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  static String _messageForStatus(int? statusCode) {
    switch (statusCode) {
      case 401:
        return '登录已失效，请重新登录';
      case 403:
        return '当前账号无权限访问';
      case 404:
        return '请求资源不存在';
      case 500:
      case 502:
      case 503:
        return '服务暂时不可用，请稍后重试';
      default:
        return '网络请求失败，请稍后重试';
    }
  }

  @override
  String toString() {
    return 'AppException(type: $type, code: $code, message: $message)';
  }
}
