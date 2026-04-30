import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import 'my_section_shell.dart';

/// 未登录时展示的引导卡片。
class LoginPromptSection extends StatelessWidget {
  const LoginPromptSection({
    super.key,
    required this.onLoginTap,
  });

  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        onTap: onLoginTap,
        child: MySectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: AppSpacing.xl + AppSpacing.sm,
                height: AppSpacing.xl + AppSpacing.sm,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAccent,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: const Icon(
                  Icons.account_circle_outlined,
                  color: AppColors.accent,
                  size: AppSpacing.lg,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                '当前未登录',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                '登录后即可查看个人资料、认证状态和宠物档案。点击卡片或按钮都会跳转到登录页。',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: AppSpacing.xl + AppSpacing.sm,
                child: FilledButton(
                  onPressed: onLoginTap,
                  child: const Text('去登录'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
