import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../shared/models/user_models.dart';
import 'my_section_shell.dart';
import 'responsive_wrap.dart';

/// 登录后的用户资料总览卡片。
class ProfileOverviewSection extends StatelessWidget {
  const ProfileOverviewSection({
    super.key,
    required this.profile,
    required this.isRefreshing,
  });

  final UserProfileModel profile;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final List<_ProfileInfoItem> infoItems = <_ProfileInfoItem>[
      _ProfileInfoItem(
        label: '手机号',
        value: profile.maskedPhone.isNotEmpty ? profile.maskedPhone : '未完善',
      ),
      _ProfileInfoItem(
        label: '认证状态',
        value: profile.displayStatus,
      ),
      _ProfileInfoItem(
        label: '性别',
        value: profile.displayGender,
      ),
      _ProfileInfoItem(
        label: '最近登录',
        value: AppDateUtils.formatDateTime(
          profile.lastLoginAt,
          pattern: 'yyyy-MM-dd HH:mm',
          fallback: '暂无记录',
        ),
      ),
      _ProfileInfoItem(
        label: '创建时间',
        value: AppDateUtils.formatDateTime(
          profile.createdTime,
          pattern: 'yyyy-MM-dd',
          fallback: '暂无记录',
        ),
      ),
      _ProfileInfoItem(
        label: '证件信息',
        value: profile.identitySummary.isNotEmpty
            ? profile.identitySummary
            : '未完善',
      ),
    ];

    return MySectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.surfaceAccent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: AppSpacing.xl + AppSpacing.md,
                      height: AppSpacing.xl + AppSpacing.md,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.lg),
                      ),
                      child: Center(
                        child: Text(
                          profile.displayName.characters.first.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            profile.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '用户 ID：${profile.userId}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: <Widget>[
                              _StatusChip(
                                icon: Icons.verified_user_outlined,
                                label: profile.displayStatus,
                              ),
                              _StatusChip(
                                icon: Icons.pets_rounded,
                                label: profile.petSummary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    if (isRefreshing)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    profile.petCount == 0
                        ? '当前账号还没有爱宠档案，后续接入新增或编辑能力后会直接写入 user_pet 并在这里同步展示。'
                        : '当前账号已同步 ${profile.petCount} 只爱宠，页面数据来自客户端 `/user` 聚合接口返回的 `petList`。',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double itemWidth = calculateMySectionItemWidth(
                  constraints,
                );

                return Wrap(
                  spacing: kMySectionItemSpacing,
                  runSpacing: kMySectionItemSpacing,
                  children: infoItems.map((_ProfileInfoItem item) {
                    return SizedBox(
                      width: itemWidth,
                      child: _ProfileInfoTile(item: item),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({required this.item});

  final _ProfileInfoItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoItem {
  const _ProfileInfoItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
