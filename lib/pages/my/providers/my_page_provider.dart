import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/api/user_repository.dart';
import '../../../core/network/app_exception.dart';
import '../../../core/storage/token_manager.dart';
import '../../../shared/models/user_models.dart';

/// 我的页面状态提供者，负责登录态同步、资料加载与错误管理。
class MyPageProvider extends ChangeNotifier {
  MyPageProvider({
    required UserRepository userRepository,
    required TokenManager tokenManager,
  })  : _userRepository = userRepository,
        _tokenManager = tokenManager;

  final UserRepository _userRepository;
  final TokenManager _tokenManager;

  UserProfileModel? _profile;
  bool _isLoading = false;
  bool _initialized = false;
  bool _disposed = false;
  String _errorMessage = '';
  int _requestVersion = 0;

  UserProfileModel? get profile => _profile;

  bool get isLoading => _isLoading;

  bool get isLoggedIn => _tokenManager.isLoggedIn;

  bool get hasError => _errorMessage.isNotEmpty;

  bool get isInitialLoading => _isLoading && _profile == null;

  String get errorMessage => _errorMessage;

  /// 初始化监听，并在已登录时首次拉取页面数据。
  void initialize() {
    if (_initialized) {
      return;
    }

    _initialized = true;
    _tokenManager.addListener(_handleTokenChanged);
    unawaited(_syncWithTokenState());
  }

  /// 重新拉取当前页面数据。
  Future<void> refresh() async {
    if (!isLoggedIn) {
      _resetState(notify: true);
      return;
    }

    final int requestVersion = ++_requestVersion;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final UserProfileModel profile =
          await _userRepository.fetchCurrentUserProfile();
      if (_disposed || requestVersion != _requestVersion) {
        return;
      }
      _profile = profile;
    } on AppException catch (error) {
      if (_disposed || requestVersion != _requestVersion) {
        return;
      }
      _profile = null;
      _errorMessage = error.message;
    } catch (_) {
      if (_disposed || requestVersion != _requestVersion) {
        return;
      }
      _profile = null;
      _errorMessage = '我的页面数据加载失败，请稍后重试';
    } finally {
      if (_disposed || requestVersion != _requestVersion) {
        return;
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _tokenManager.removeListener(_handleTokenChanged);
    super.dispose();
  }

  void _handleTokenChanged() {
    unawaited(_syncWithTokenState());
  }

  Future<void> _syncWithTokenState() async {
    if (!isLoggedIn) {
      _resetState(notify: true);
      return;
    }

    await refresh();
  }

  void _resetState({required bool notify}) {
    _profile = null;
    _isLoading = false;
    _errorMessage = '';
    _requestVersion += 1;
    if (notify && !_disposed) {
      notifyListeners();
    }
  }
}
