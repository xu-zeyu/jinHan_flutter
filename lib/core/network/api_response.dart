import '../utils/json_utils.dart';
import 'app_exception.dart';

/// Standard backend response wrapper: `code + msg + data`.
class ApiResponse<T> {
  const ApiResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.raw,
  });

  final String code;
  final String message;
  final T? data;
  final Map<String, dynamic> raw;

  bool get isSuccess =>
      code == '200' || code == '0' || code.toLowerCase() == 'success';

  bool get isUnauthorized => code == '401' || code == '403';

  T requireData({String? fallbackMessage}) {
    if (data != null) {
      return data as T;
    }

    throw AppException.data(fallbackMessage ?? '响应数据为空');
  }

  factory ApiResponse.fromJson(
    dynamic source, {
    T Function(dynamic value)? decoder,
  }) {
    final raw = JsonUtils.asMap(source);
    final fallbackCode = JsonUtils.asBool(raw['success'])
        ? '200'
        : JsonUtils.asString(raw['status']);

    return ApiResponse<T>(
      code: JsonUtils.asString(raw['code'], fallback: fallbackCode),
      message: JsonUtils.asString(
        raw['msg'],
        fallback: JsonUtils.asString(raw['message']),
      ),
      data: _decodeData(raw['data'], decoder),
      raw: raw,
    );
  }

  static T? _decodeData<T>(
    dynamic value,
    T Function(dynamic value)? decoder,
  ) {
    if (decoder != null) {
      return decoder(value);
    }

    if (value is T) {
      return value;
    }

    return value as T?;
  }
}
