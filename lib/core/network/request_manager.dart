import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../storage/token_manager.dart';
import 'api_response.dart';
import 'app_exception.dart';

/// Shared HTTP client that owns base URL, headers and error normalization.
class RequestManager {
  static const String defaultBaseUrl = 'http://192.168.9.144:8088';

  static RequestManager? _instance;

  factory RequestManager({TokenManager? tokenManager}) {
    _instance ??= RequestManager._internal(
      tokenManager ?? TokenManager.instance,
    );
    return _instance!;
  }

  RequestManager._internal(this._tokenManager) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 5000),
        baseUrl: _resolveBaseUrl(),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final headers = <String, dynamic>{...options.headers};
          final authorizationHeader = _tokenManager.authorizationHeader;

          if (authorizationHeader != null) {
            headers['Authorization'] = authorizationHeader;
          }
          headers['source-client'] ??= 'app';
          options.headers = headers;
          handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          if (statusCode == 401 || statusCode == 403) {
            await _tokenManager.clearToken();
          }
          handler.next(error);
        },
      ),
    );
  }

  final TokenManager _tokenManager;
  late final Dio _dio;

  String get baseUrl => _dio.options.baseUrl;

  String resolveUrl(String path) {
    if (path.isEmpty) {
      return path;
    }

    final uri = Uri.tryParse(path);
    if (uri != null && uri.hasScheme) {
      return path;
    }

    final baseUri = Uri.tryParse(baseUrl);
    if (baseUri == null) {
      return path;
    }

    return baseUri.resolve(path).toString();
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    T Function(dynamic value)? decoder,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
      decoder: decoder,
      cancelToken: cancelToken,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    T Function(dynamic value)? decoder,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
      decoder: decoder,
      cancelToken: cancelToken,
    );
  }

  Future<ApiResponse<T>> request<T>(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    T Function(dynamic value)? decoder,
    CancelToken? cancelToken,
  }) async {
    try {
      final mergedHeaders = <String, dynamic>{
        ...?options?.headers,
        ...?headers,
      };

      final response = await _dio.request<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: (options ?? Options()).copyWith(
          method: method,
          headers: mergedHeaders.isEmpty ? null : mergedHeaders,
        ),
      );

      final apiResponse = ApiResponse<T>.fromJson(
        response.data,
        decoder: decoder,
      );

      if (!apiResponse.isSuccess) {
        if (apiResponse.isUnauthorized) {
          await _tokenManager.clearToken();
        }

        throw AppException.business(
          code: apiResponse.code,
          message: apiResponse.message,
        );
      }

      return apiResponse;
    } on DioException catch (error) {
      throw AppException.fromDioException(error);
    } on AppException {
      rethrow;
    } catch (error, stackTrace) {
      throw AppException.unknown(error, stackTrace);
    }
  }

  static String _resolveBaseUrl() {
    final envBaseUrl = dotenv.env['BASE_URL']?.trim();
    if (envBaseUrl == null || envBaseUrl.isEmpty) {
      return defaultBaseUrl;
    }
    return envBaseUrl;
  }
}
