import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'my_section_shell.dart';
import 'responsive_wrap.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.onThemeTap,
  });

  static const List<_SettingItemData> _items = <_SettingItemData>[
    _SettingItemData(
      title: '主题外观',
      subtitle: '浅色 / 深色 / 金色',
      icon: Icons.palette_outlined,
      action: _SettingAction.theme,
    ),
    _SettingItemData(
      title: '账号与安全',
      subtitle: '设备、隐私、支付',
      icon: Icons.verified_user_outlined,
    ),
    _SettingItemData(
      title: '通知偏好',
      subtitle: '消息提醒与营销通知',
      icon: Icons.notifications_none_rounded,
    ),
    _SettingItemData(
      title: '通用设置',
      subtitle: '缓存、语言、辅助功能',
      icon: Icons.tune_rounded,
    ),
  ];

  final VoidCallback onThemeTap;

  @override
  Widget build(BuildContext context) {
    return MySectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: MySectionHeader(
              title: '设置',
              subtitle: '把偏好类配置统一沉到底部，主体区域只保留关键业务信息。',
              trailing: '管理',
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double itemWidth = calculateMySectionItemWidth(
                  constraints,
                );

                return Wrap(
                  spacing: kMySectionItemSpacing,
                  runSpacing: kMySectionItemSpacing,
                  children: _items.map((_SettingItemData item) {
                    return SizedBox(
                      width: itemWidth,
                      child: _SettingsTile(
                        item: item,
                        onTap: item.action == _SettingAction.theme
                            ? onThemeTap
                            : null,
                      ),
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.item,
    this.onTap,
  });

  final _SettingItemData item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  size: 18,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _SettingAction {
  none,
  theme,
}

class _SettingItemData {
  const _SettingItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.action = _SettingAction.none,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final _SettingAction action;
}
