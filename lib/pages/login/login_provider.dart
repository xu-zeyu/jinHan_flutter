import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/api/login_repository.dart';
import '../../core/network/app_exception.dart';
import '../../core/storage/token_manager.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/json_utils.dart';

/// Login page provider that handles SMS sending, countdown and token persistence.
class LoginProvider extends ChangeNotifier {
  LoginProvider({
    required LoginRepository loginRepository,
    required TokenManager tokenManager,
  })  : _loginRepository = loginRepository,
        _tokenManager = tokenManager;

  static const int _initialCountdown = 60;

  final LoginRepository _loginRepository;
  final TokenManager _tokenManager;

  Timer? _countdownTimer;
  int _countdown = 0;
  bool _isSendingCode = false;
  bool _isSubmitting = false;

  int get countdown => _countdown;

  bool get isCountingDown => _countdown > 0;

  bool get isSendingCode => _isSendingCode;

  bool get isSubmitting => _isSubmitting;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// Requests the login SMS captcha and starts the local countdown on success.
  Future<void> sendLoginCaptcha({required String phone}) async {
    if (_isSendingCode || isCountingDown) {
      return;
    }

    _isSendingCode = true;
    notifyListeners();

    try {
      await _loginRepository.sendLoginCaptcha(phone: phone);
      _startCountdown();
    } finally {
      _isSendingCode = false;
      notifyListeners();
    }
  }

  /// Completes SMS login and stores the returned token into the shared manager.
  Future<void> loginWithSms({
    required String phone,
    required String smsCode,
  }) async {
    if (_isSubmitting) {
      return;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final raw = await _loginRepository.loginWithSms(
        phone: phone,
        password: "123456",
        smsCode: smsCode,
      );
      await _saveToken(raw);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdown = _initialCountdown;
    notifyListeners();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
        _countdown = 0;
        notifyListeners();
        return;
      }

      _countdown -= 1;
      notifyListeners();
    });
  }

  /// Extracts token fields from common backend payload shapes.
  Future<void> _saveToken(Map<String, dynamic> raw) async {
    final candidates = <Map<String, dynamic>>[
      JsonUtils.asMap(raw['data']),
      JsonUtils.asMap(JsonUtils.asMap(raw['data'])['tokenInfo']),
      JsonUtils.asMap(JsonUtils.asMap(raw['data'])['auth']),
      raw,
      JsonUtils.asMap(raw['tokenInfo']),
      JsonUtils.asMap(raw['auth']),
    ];

    final accessToken = _readFirstString(
      candidates,
      const <String>[
        'accessToken',
        'token',
        'access_token',
        'Authorization',
        'authorization',
      ],
      fallback: JsonUtils.asString(raw['data']),
    );

    if (accessToken.isEmpty) {
      throw AppException.data('登录成功，但未获取到登录凭证');
    }

    await _tokenManager.saveToken(
      accessToken: accessToken,
      refreshToken: _readFirstString(
        candidates,
        const <String>['refreshToken', 'refresh_token'],
      ),
      expiresAt: AppDateUtils.tryParse(
        _readFirstDynamic(
          candidates,
          const <String>[
            'expiresAt',
            'expireTime',
            'expiredAt',
            'expiration',
          ],
        ),
      ),
    );
  }

  String _readFirstString(
    List<Map<String, dynamic>> candidates,
    List<String> keys, {
    String fallback = '',
  }) {
    final value = _readFirstDynamic(candidates, keys);
    return JsonUtils.asString(value, fallback: fallback);
  }

  dynamic _readFirstDynamic(
    List<Map<String, dynamic>> candidates,
    List<String> keys,
  ) {
    for (final candidate in candidates) {
      for (final key in keys) {
        if (!candidate.containsKey(key)) {
          continue;
        }

        final value = candidate[key];
        if (value == null) {
          continue;
        }

        if (value is String && value.trim().isEmpty) {
          continue;
        }

        return value;
      }
    }

    return null;
  }
}
