import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// 登录页品牌 Logo 区域。
class LoginLogoWidget extends StatelessWidget {
  const LoginLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: AppSpacing.xl * 2 + AppSpacing.md,
          height: AppSpacing.xl * 2 + AppSpacing.md,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColors.headerGradientStart,
                AppColors.headerGradientMid1,
              ],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.lg),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: AppSpacing.lg,
                offset: Offset(0, AppSpacing.sm),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'JH',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w800,
                letterSpacing: AppSpacing.xs / 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'JinHan',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: AppSpacing.md + AppSpacing.sm,
          ),
        ),
      ],
    );
  }
}
