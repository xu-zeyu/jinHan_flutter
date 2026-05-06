import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// 我的页面模块卡片容器。
class MySectionCard extends StatelessWidget {
  const MySectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.border),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppSpacing.md,
            offset: Offset(0, AppSpacing.xs),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// 我的页面模块标题栏。
class MySectionHeader extends StatelessWidget {
  const MySectionHeader({
    super.key,
    required this.title,
    required this.trailing,
    this.subtitle,
  });

  final String title;
  final String trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppSpacing.md,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle != null) ...<Widget>[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSpacing.sm + AppSpacing.xs,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
        Text(
          trailing,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppSpacing.sm + AppSpacing.xs,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
