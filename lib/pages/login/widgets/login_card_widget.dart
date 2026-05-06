import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import 'login_logo_widget.dart';
import 'login_text_field_widget.dart';
import 'otp_countdown_button_widget.dart';

/// 登录卡片，组合品牌区、账户密码验证码表单与登录按钮。
class LoginCardWidget extends StatelessWidget {
  const LoginCardWidget({
    super.key,
    required this.accountController,
    required this.passwordController,
    required this.captchaController,
    required this.isPasswordVisible,
    required this.countdown,
    required this.isCountingDown,
    required this.isSendingCode,
    required this.isSubmitting,
    required this.onTogglePasswordVisible,
    required this.onSendCode,
    required this.onLogin,
  });

  static const double _panelAlpha = 0.94;
  static const double _borderAlpha = 0.72;
  static const double _borderWidth = AppSpacing.xs / 4;

  final TextEditingController accountController,
      passwordController,
      captchaController;
  final bool isPasswordVisible;
  final int countdown;
  final bool isCountingDown, isSendingCode, isSubmitting;
  final VoidCallback onTogglePasswordVisible, onSendCode, onLogin;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSpacing.xl * 13),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const LoginLogoWidget(),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: _panelAlpha),
              borderRadius: BorderRadius.circular(AppSpacing.md),
              border: Border.all(
                color: AppColors.border.withValues(alpha: _borderAlpha),
                width: _borderWidth,
              ),
            ),
            child: _buildForm(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('账户登录', style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.lg),
        LoginTextFieldWidget(
          label: '账户名',
          controller: accountController,
          hintText: '请输入绑定手机号',
          prefixIcon: Icons.account_circle_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        LoginTextFieldWidget(
          label: '密码',
          controller: passwordController,
          hintText: '请输入密码',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: !isPasswordVisible,
          textInputAction: TextInputAction.next,
          suffixIcon: IconButton(
            tooltip: isPasswordVisible ? '隐藏密码' : '显示密码',
            onPressed: onTogglePasswordVisible,
            icon: Icon(
              isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildCaptchaRow(),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: LoginTextFieldWidget.fieldHeight,
          child: FilledButton(
            onPressed: isSubmitting ? null : onLogin,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.borderStrong,
              foregroundColor: AppColors.textPrimary,
              disabledForegroundColor: AppColors.textSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
            ),
            child: isSubmitting ? const Text('登录中') : const Text('登录'),
          ),
        ),
      ],
    );
  }

  Widget _buildCaptchaRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: LoginTextFieldWidget(
            label: '验证码',
            controller: captchaController,
            hintText: '请输入验证码',
            prefixIcon: Icons.verified_user_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          height: LoginTextFieldWidget.fieldHeight,
          child: OtpCountdownButtonWidget(
            countdown: countdown,
            isCountingDown: isCountingDown,
            isLoading: isSendingCode,
            onPressed: onSendCode,
          ),
        ),
      ],
    );
  }
}
