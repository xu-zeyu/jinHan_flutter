import 'package:intl/intl.dart';

/// Common date parsing and formatting helpers used across the app.
class AppDateUtils {
  const AppDateUtils._();

  static DateTime now() => DateTime.now();

  static DateTime? tryParse(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    if (value is num) {
      return _fromTimestamp(value.toInt());
    }

    final raw = value.toString().trim();
    if (raw.isEmpty) {
      return null;
    }

    final timestamp = int.tryParse(raw);
    if (timestamp != null) {
      return _fromTimestamp(timestamp);
    }

    return DateTime.tryParse(raw);
  }

  static String formatDate(
    DateTime? value, {
    String pattern = 'yyyy-MM-dd',
    String fallback = '',
  }) {
    if (value == null) {
      return fallback;
    }

    return DateFormat(pattern).format(value);
  }

  static String formatDateTime(
    DateTime? value, {
    String pattern = 'yyyy-MM-dd HH:mm:ss',
    String fallback = '',
  }) {
    return formatDate(value, pattern: pattern, fallback: fallback);
  }

  static DateTime startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static DateTime endOfDay(DateTime value) {
    return DateTime(
      value.year,
      value.month,
      value.day,
      23,
      59,
      59,
      999,
      999,
    );
  }

  static DateTime addDays(DateTime value, int days) {
    return value.add(Duration(days: days));
  }

  static bool isSameDay(DateTime? left, DateTime? right) {
    if (left == null || right == null) {
      return false;
    }

    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  static bool isExpired(DateTime? value, {DateTime? reference}) {
    if (value == null) {
      return false;
    }

    return !value.isAfter(reference ?? now());
  }

  static DateTime? _fromTimestamp(int value) {
    if (value <= 0) {
      return null;
    }

    final milliseconds = value.toString().length <= 10 ? value * 1000 : value;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }
}
