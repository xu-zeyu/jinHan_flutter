import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import 'my_module_illustration_widget.dart';
import 'my_section_shell.dart';

/// 模块卡片动画类型。
enum MyModuleAnimationType {
  order,
  petBoarding,
  general,
}

/// 模块卡片顶部指标数据。
class MyModuleMetricData {
  const MyModuleMetricData({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

/// 模块卡片功能入口数据。
class MyModuleActionData {
  const MyModuleActionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
}

/// 我的页面模块展示卡片，负责统一渲染标题、动效和功能入口。
class MyModuleShowcaseCard extends StatelessWidget {
  const MyModuleShowcaseCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.accentColor,
    required this.backgroundColor,
    required this.animationType,
    required this.metrics,
    required this.actions,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final Color accentColor;
  final Color backgroundColor;
  final MyModuleAnimationType animationType;
  final List<MyModuleMetricData> metrics;
  final List<MyModuleActionData> actions;

  @override
  Widget build(BuildContext context) {
    return MySectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MySectionHeader(
            title: title,
            subtitle: subtitle,
            trailing: trailing,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: AppSpacing.xl * 4 + AppSpacing.md,
                child: MyModuleIllustrationWidget(
                  type: animationType,
                  accentColor: accentColor,
                  backgroundColor: backgroundColor,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: metrics
                        .map(
                          (MyModuleMetricData metric) => _ModuleMetricChip(
                            metric: metric,
                            accentColor: accentColor,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              const int columnCount = 3;
              final double itemWidth =
                  (constraints.maxWidth - AppSpacing.sm * (columnCount - 1)) /
                      columnCount;
              return Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: actions
                    .map(
                      (MyModuleActionData action) => SizedBox(
                        width: itemWidth,
                        height: AppSpacing.xl * 3 + AppSpacing.sm,
                        child: _ModuleActionTile(
                          action: action,
                          accentColor: accentColor,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ModuleMetricChip extends StatelessWidget {
  const _ModuleMetricChip({
    required this.metric,
    required this.accentColor,
  });

  final MyModuleMetricData metric;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints(minHeight: AppSpacing.xl + AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              metric.value,
              style: TextStyle(
                color: accentColor,
                fontSize: AppSpacing.md,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              metric.label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppSpacing.sm + AppSpacing.xs,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleActionTile extends StatelessWidget {
  const _ModuleActionTile({
    required this.action,
    required this.accentColor,
  });

  final MyModuleActionData action;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        onTap: action.onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + AppSpacing.xs,
            vertical: AppSpacing.sm + AppSpacing.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: AppSpacing.md + AppSpacing.lg,
                height: AppSpacing.md + AppSpacing.lg,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.sm + AppSpacing.xs),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(
                  action.icon,
                  size: AppSpacing.md,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                action.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppSpacing.sm + AppSpacing.xs,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    action.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppSpacing.sm,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
