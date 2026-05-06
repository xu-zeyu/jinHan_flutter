import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/api/login_repository.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/network/app_exception.dart';
import '../../core/network/request_manager.dart';
import '../../core/storage/token_manager.dart';
import 'login_provider.dart';
import 'widgets/login_background_widget.dart';
import 'widgets/login_card_widget.dart';

/// 登录页面，承载账户名、密码、验证码登录的状态与交互。
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  String get _account => _accountController.text.replaceAll(' ', '').trim();

  String get _password => _passwordController.text.trim();

  String get _captcha => _captchaController.text.replaceAll(' ', '').trim();

  bool _isValidAccount(String value) => RegExp(r'^1\d{10}$').hasMatch(value);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// 发送登录验证码，并复用 provider 的倒计时状态。
  Future<void> _handleSendCode(LoginProvider provider) async {
    if (!_isValidAccount(_account)) {
      _showMessage('请输入正确的 11 位账户手机号');
      return;
    }

    try {
      await provider.sendLoginCaptcha(phone: _account);
      if (mounted) {
        _showMessage('验证码已发送，请注意查收');
      }
    } on AppException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    }
  }

  /// 提交账户名、密码和验证码，登录成功后进入首页。
  Future<void> _handleLogin(LoginProvider provider) async {
    if (!_isValidAccount(_account)) {
      _showMessage('请输入正确的 11 位账户手机号');
      return;
    }

    if (_password.isEmpty) {
      _showMessage('请输入密码');
      return;
    }

    if (_captcha.isEmpty) {
      _showMessage('请输入验证码');
      return;
    }

    try {
      await provider.loginWithSms(
        phone: _account,
        password: _password,
        smsCode: _captcha,
      );
      if (mounted) {
        context.go('/');
      }
    } on AppException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginProvider>(
      create: (context) => LoginProvider(
        loginRepository: LoginRepository(
          requestManager: context.read<RequestManager>(),
        ),
        tokenManager: context.read<TokenManager>(),
      ),
      child: Consumer<LoginProvider>(
        builder: (context, provider, _) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: Stack(
                children: <Widget>[
                  const LoginBackgroundWidget(),
                  SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: LoginCardWidget(
                          accountController: _accountController,
                          passwordController: _passwordController,
                          captchaController: _captchaController,
                          isPasswordVisible: _isPasswordVisible,
                          countdown: provider.countdown,
                          isCountingDown: provider.isCountingDown,
                          isSendingCode: provider.isSendingCode,
                          isSubmitting: provider.isSubmitting,
                          onTogglePasswordVisible: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          onSendCode: () => _handleSendCode(provider),
                          onLogin: () => _handleLogin(provider),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
