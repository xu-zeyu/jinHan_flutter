import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// 登录页底部辅助操作区域。
class LoginFooterActionsWidget extends StatelessWidget {
  const LoginFooterActionsWidget({
    super.key,
    required this.onForgotPassword,
    required this.onRegister,
  });

  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        TextButton(
          onPressed: onForgotPassword,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
          ),
          child: const Text('忘记密码'),
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: onRegister,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.borderStrong),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppSpacing.md + AppSpacing.xs),
            ),
          ),
          child: const Text('注册账号'),
        ),
      ],
    );
  }
}
