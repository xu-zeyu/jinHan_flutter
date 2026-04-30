import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../providers/my_page_provider.dart';
import 'login_prompt_section.dart';
import 'my_section_entry.dart';
import 'pet_section.dart';
import 'profile_overview_section.dart';
import 'settings_section.dart';

/// 我的页面主体，根据登录态和接口数据切换不同视图。
class MyPageBody extends StatelessWidget {
  const MyPageBody({
    super.key,
    required this.entranceController,
    required this.onThemeTap,
    required this.onLoginTap,
  });

  final AnimationController entranceController;
  final VoidCallback onThemeTap;
  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    final MyPageProvider provider = context.watch<MyPageProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm + 4,
        AppSpacing.md,
        AppSpacing.xl + 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildSections(provider),
      ),
    );
  }

  List<Widget> _buildSections(MyPageProvider provider) {
    final List<Widget> sections = <Widget>[];

    if (!provider.isLoggedIn) {
      sections.add(
        MySectionEntry(
          controller: entranceController,
          index: 0,
          child: LoginPromptSection(onLoginTap: onLoginTap),
        ),
      );
    } else if (provider.isInitialLoading) {
      sections.add(
        MySectionEntry(
          controller: entranceController,
          index: 0,
          child: const _LoadingSection(),
        ),
      );
    } else if (provider.hasError) {
      sections.add(
        MySectionEntry(
          controller: entranceController,
          index: 0,
          child: _ErrorSection(
            message: provider.errorMessage,
            onRetry: provider.refresh,
          ),
        ),
      );
    } else if (provider.profile != null) {
      sections.add(
        MySectionEntry(
          controller: entranceController,
          index: 0,
          child: ProfileOverviewSection(
            profile: provider.profile!,
            isRefreshing: provider.isLoading,
          ),
        ),
      );
      sections.add(const SizedBox(height: AppSpacing.sm + 4));
      sections.add(
        MySectionEntry(
          controller: entranceController,
          index: 1,
          child: PetSection(pets: provider.profile!.petList),
        ),
      );
    }

    if (sections.isNotEmpty) {
      sections.add(const SizedBox(height: AppSpacing.sm + 4));
    }

    sections.add(
      MySectionEntry(
        controller: entranceController,
        index: 2,
        child: SettingsSection(onThemeTap: onThemeTap),
      ),
    );

    return sections;
  }
}

class _LoadingSection extends StatelessWidget {
  const _LoadingSection();

  @override
  Widget build(BuildContext context) {
    return _StateCard(
      icon: const SizedBox(
        width: AppSpacing.lg,
        height: AppSpacing.lg,
        child: CircularProgressIndicator(strokeWidth: 2.2),
      ),
      title: '正在同步我的资料',
      message: '已登录，正在拉取 `/user` 聚合接口返回的用户信息和宠物列表。',
    );
  }
}

class _ErrorSection extends StatelessWidget {
  const _ErrorSection({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return _StateCard(
      icon: const Icon(
        Icons.error_outline_rounded,
        size: AppSpacing.lg + 4,
        color: AppColors.danger,
      ),
      title: '资料加载失败',
      message: message.isNotEmpty ? message : '请稍后重试',
      action: FilledButton(
        onPressed: () {
          onRetry();
        },
        child: const Text('重新加载'),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final Widget icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: <Widget>[
          icon,
          const SizedBox(height: AppSpacing.sm + 4),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          if (action != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            action!,
          ],
        ],
      ),
    );
  }
}
