import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import 'login_footer_actions_widget.dart';
import 'login_logo_widget.dart';
import 'login_text_field_widget.dart';
import 'otp_countdown_button_widget.dart';

/// 登录卡片，组合 Logo、输入区、主按钮与辅助入口。
class LoginCardWidget extends StatelessWidget {
  const LoginCardWidget({
    super.key,
    required this.phoneController,
    required this.codeController,
    required this.countdown,
    required this.isCountingDown,
    required this.isSendingCode,
    required this.isSubmitting,
    required this.onSendCode,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onRegister,
  });

  static const double _cardMaxWidth = AppSpacing.xl * 13;
  static const double _blurSigma = AppSpacing.md + AppSpacing.sm;
  static const double _buttonHeight = AppSpacing.xl + AppSpacing.lg;

  final TextEditingController phoneController;
  final TextEditingController codeController;
  final int countdown;
  final bool isCountingDown;
  final bool isSendingCode;
  final bool isSubmitting;
  final VoidCallback onSendCode;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _cardMaxWidth),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(AppSpacing.lg),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.7),
              ),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: AppSpacing.xl,
                  offset: Offset(0, AppSpacing.md),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const LoginLogoWidget(),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  '手机号登录',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: AppSpacing.lg + AppSpacing.sm,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '使用验证码快速进入 JinHan',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                LoginTextFieldWidget(
                  controller: phoneController,
                  hintText: '请输入手机号',
                  prefixIcon: Icons.phone_iphone_rounded,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: LoginTextFieldWidget(
                        controller: codeController,
                        hintText: '请输入验证码',
                        prefixIcon: Icons.lock_outline_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    OtpCountdownButtonWidget(
                      countdown: countdown,
                      isCountingDown: isCountingDown,
                      isLoading: isSendingCode,
                      onPressed: onSendCode,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: _buttonHeight,
                  child: FilledButton(
                    onPressed: isSubmitting ? null : onLogin,
                    child: Text(isSubmitting ? '登录中...' : '登录'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                LoginFooterActionsWidget(
                  onForgotPassword: onForgotPassword,
                  onRegister: onRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
