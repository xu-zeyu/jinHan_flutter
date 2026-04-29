import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_date_utils.dart';
import '../utils/json_utils.dart';

/// Immutable view of the tokens currently cached on the device.
class TokenSnapshot {
  const TokenSnapshot({
    this.accessToken = '',
    this.refreshToken = '',
    this.expiresAt,
  });

  static const empty = TokenSnapshot();

  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;

  bool get hasAccessToken => accessToken.isNotEmpty;

  bool get isExpired => AppDateUtils.isExpired(expiresAt);

  String? get authorizationHeader {
    if (!hasAccessToken) {
      return null;
    }

    if (accessToken.startsWith('Bearer ')) {
      return accessToken;
    }

    return 'Bearer $accessToken';
  }

  TokenSnapshot copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    bool clearExpiresAt = false,
  }) {
    return TokenSnapshot(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: clearExpiresAt ? null : expiresAt ?? this.expiresAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  factory TokenSnapshot.fromJson(Map<String, dynamic> json) {
    return TokenSnapshot(
      accessToken: JsonUtils.asString(json['accessToken']),
      refreshToken: JsonUtils.asString(json['refreshToken']),
      expiresAt: AppDateUtils.tryParse(json['expiresAt']),
    );
  }
}

/// Central token manager for persistence, in-memory cache and auth headers.
class TokenManager extends ChangeNotifier {
  TokenManager._internal();

  static const String _cacheKey = 'auth.token.snapshot';
  static final TokenManager instance = TokenManager._internal();

  SharedPreferences? _preferences;
  TokenSnapshot _snapshot = TokenSnapshot.empty;

  TokenSnapshot get snapshot => _snapshot;

  String get accessToken => _snapshot.accessToken;

  String get refreshToken => _snapshot.refreshToken;

  DateTime? get expiresAt => _snapshot.expiresAt;

  bool get hasToken => _snapshot.hasAccessToken;

  bool get isTokenExpired => _snapshot.isExpired;

  bool get isLoggedIn => hasToken && !isTokenExpired;

  String? get authorizationHeader => _snapshot.authorizationHeader;

  factory TokenManager() => instance;

  Future<void> init() async {
    if (_preferences != null) {
      return;
    }

    _preferences = await SharedPreferences.getInstance();
    _restoreSnapshot();
  }

  Future<void> saveToken({
    required String accessToken,
    String refreshToken = '',
    DateTime? expiresAt,
  }) async {
    _snapshot = TokenSnapshot(
      accessToken: accessToken.trim(),
      refreshToken: refreshToken.trim(),
      expiresAt: expiresAt,
    );

    await _persistSnapshot();
    notifyListeners();
  }

  Future<void> saveTokenFromJson(
    Map<String, dynamic> json, {
    String accessTokenKey = 'accessToken',
    String refreshTokenKey = 'refreshToken',
    String expiresAtKey = 'expiresAt',
  }) {
    return saveToken(
      accessToken: JsonUtils.asString(json[accessTokenKey]),
      refreshToken: JsonUtils.asString(json[refreshTokenKey]),
      expiresAt: AppDateUtils.tryParse(json[expiresAtKey]),
    );
  }

  Future<void> clearToken() async {
    _snapshot = TokenSnapshot.empty;
    final preferences = _preferences;
    if (preferences != null) {
      await preferences.remove(_cacheKey);
    }
    notifyListeners();
  }

  void _restoreSnapshot() {
    final raw = _preferences?.getString(_cacheKey);
    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        _snapshot = TokenSnapshot.fromJson(JsonUtils.asMap(decoded));
      }
    } catch (_) {
      _snapshot = TokenSnapshot.empty;
    }
  }

  Future<void> _persistSnapshot() async {
    final preferences = _preferences;
    if (preferences == null) {
      return;
    }

    if (!hasToken && refreshToken.isEmpty && expiresAt == null) {
      await preferences.remove(_cacheKey);
      return;
    }

    await preferences.setString(_cacheKey, jsonEncode(_snapshot.toJson()));
  }
}
