import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// 验证码倒计时按钮，仅处理展示与点击透传。
class OtpCountdownButtonWidget extends StatelessWidget {
  const OtpCountdownButtonWidget({
    super.key,
    required this.countdown,
    required this.isCountingDown,
    required this.isLoading,
    required this.onPressed,
  });

  static const double _buttonWidth = AppSpacing.xl * 3 + AppSpacing.lg;

  final int countdown;
  final bool isCountingDown;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _buttonWidth,
      child: OutlinedButton(
        onPressed: isCountingDown || isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.surface,
          disabledForegroundColor:
              AppColors.textSecondary.withValues(alpha: 0.72),
          disabledBackgroundColor: AppColors.surfaceMuted,
          side: BorderSide(
            color: isCountingDown ? AppColors.border : AppColors.borderStrong,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md + AppSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md + AppSpacing.xs),
          ),
        ),
        child: Text(
          isLoading ? '发送中' : (isCountingDown ? '${countdown}s' : '获取验证码'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
