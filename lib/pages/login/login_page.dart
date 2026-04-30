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

/// 登录页面，仅承载登录相关 UI、输入校验与跳转。
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  String get _normalizedPhone =>
      _phoneController.text.replaceAll(' ', '').trim();

  String get _normalizedSmsCode =>
      _codeController.text.replaceAll(' ', '').trim();

  bool _isValidPhone(String value) {
    return RegExp(r'^1\d{10}$').hasMatch(value);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleSendCode(LoginProvider provider) async {
    final phone = _normalizedPhone;
    if (!_isValidPhone(phone)) {
      _showMessage('请输入正确的 11 位手机号');
      return;
    }

    try {
      await provider.sendLoginCaptcha(phone: phone);
      if (!mounted) {
        return;
      }
      _showMessage('验证码已发送，请注意查收');
    } on AppException catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage(error.message);
    }
  }

  Future<void> _handleLogin(LoginProvider provider) async {
    final phone = _normalizedPhone;
    final smsCode = _normalizedSmsCode;

    if (!_isValidPhone(phone)) {
      _showMessage('请输入正确的 11 位手机号');
      return;
    }

    if (smsCode.isEmpty) {
      _showMessage('请输入短信验证码');
      return;
    }

    try {
      await provider.loginWithSms(phone: phone, smsCode: smsCode);
      if (!mounted) {
        return;
      }
      context.go('/');
    } on AppException catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage(error.message);
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
                          phoneController: _phoneController,
                          codeController: _codeController,
                          countdown: provider.countdown,
                          isCountingDown: provider.isCountingDown,
                          isSendingCode: provider.isSendingCode,
                          isSubmitting: provider.isSubmitting,
                          onSendCode: () => _handleSendCode(provider),
                          onLogin: () => _handleLogin(provider),
                          onForgotPassword: () {},
                          onRegister: () {},
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
