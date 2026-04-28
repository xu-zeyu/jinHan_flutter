import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RequestManager {
  static const String defaultBaseUrl = 'http://192.168.9.144:8088';
  Dio? dio;
  static RequestManager? _instance;

  RequestManager._init() {
    if (dio == null) {
      BaseOptions baseOptions = BaseOptions(
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 5000),
        baseUrl: _resolveBaseUrl(),
      );
      dio = Dio(baseOptions);

      dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          options.headers = <String, dynamic>{
            ...options.headers,
            'Authorization': '',
            'source-client': 'app',
          };
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ));
    }
  }

  factory RequestManager() {
    if (_instance == null) {
      _instance = RequestManager._init();
    }
    return _instance!;
  }

  String get baseUrl => dio?.options.baseUrl ?? defaultBaseUrl;

  static String _resolveBaseUrl() {
    final envBaseUrl = dotenv.env['BASE_URL']?.trim();
    if (envBaseUrl == null || envBaseUrl.isEmpty) {
      return defaultBaseUrl;
    }
    return envBaseUrl;
  }

  String resolveUrl(String path) {
    if (path.isEmpty) {
      return path;
    }

    final uri = Uri.tryParse(path);
    if (uri != null && uri.hasScheme) {
      return path;
    }

    return Uri.parse(baseUrl).resolve(path).toString();
  }

  Future<Response<T>> request<T>(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio!.request(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(method: method),
    );
  }
}
