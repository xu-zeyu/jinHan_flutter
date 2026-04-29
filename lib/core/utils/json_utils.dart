import 'dart:convert';

/// Safe parsing helpers for the backend's loosely typed JSON payloads.
class JsonUtils {
  const JsonUtils._();

  static String asString(dynamic value, {String fallback = ''}) {
    if (value == null) {
      return fallback;
    }

    final normalized = value.toString().trim();
    return normalized.isEmpty ? fallback : normalized;
  }

  static int asInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value == null) {
      return fallback;
    }

    return int.tryParse(value.toString()) ?? fallback;
  }

  static double asDouble(dynamic value, {double fallback = 0}) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value == null) {
      return fallback;
    }

    return double.tryParse(value.toString()) ?? fallback;
  }

  static bool asBool(dynamic value, {bool fallback = false}) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    final normalized = asString(value).toLowerCase();
    if (normalized.isEmpty) {
      return fallback;
    }

    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'yes' ||
        normalized == 'y';
  }

  static Map<String, dynamic> asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    if (value is String) {
      final decoded = _tryDecode(value);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    }

    return <String, dynamic>{};
  }

  static List<dynamic> asList(dynamic value) {
    if (value is List) {
      return value;
    }

    if (value is String) {
      final decoded = _tryDecode(value);
      if (decoded is List) {
        return decoded;
      }
    }

    return const <dynamic>[];
  }

  static List<Map<String, dynamic>> asListOfMap(dynamic value) {
    return asList(value)
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  static List<String> parseStringList(
    dynamic value, {
    bool fallbackToSingleValue = false,
  }) {
    if (value is List) {
      return value.map(asString).where((item) => item.isNotEmpty).toList();
    }

    final raw = asString(value);
    if (raw.isEmpty) {
      return const <String>[];
    }

    final decoded = _tryDecode(raw);
    if (decoded is List) {
      return decoded.map(asString).where((item) => item.isNotEmpty).toList();
    }

    if (fallbackToSingleValue) {
      return <String>[raw];
    }

    return const <String>[];
  }

  static dynamic _tryDecode(String raw) {
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }
}
