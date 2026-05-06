import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// 登录页品牌区域。
class LoginLogoWidget extends StatelessWidget {
  const LoginLogoWidget({super.key});

  static const double _logoSize = AppSpacing.xl + AppSpacing.lg;
  static const double _surfaceAlpha = 0.18;
  static const double _borderAlpha = 0.72;
  static const double _borderWidth = AppSpacing.xs / 4;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        Container(
          width: _logoSize,
          height: _logoSize,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: _surfaceAlpha),
            borderRadius: BorderRadius.circular(AppSpacing.md),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: _borderAlpha),
              width: _borderWidth,
            ),
          ),
          child: Image.asset('assets/images/app_icon.png'),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'JinHan',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: AppColors.surface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '金涵宠物会员中心',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
