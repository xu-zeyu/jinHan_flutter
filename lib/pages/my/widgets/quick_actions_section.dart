import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'my_section_shell.dart';
import 'responsive_wrap.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  static const List<_QuickActionData> _actions = <_QuickActionData>[
    _QuickActionData(
      title: '专属客服',
      subtitle: '1v1 服务',
      tag: '在线',
      icon: Icons.support_agent_rounded,
      color: AppColors.quickActionCustomerService,
    ),
    _QuickActionData(
      title: '优惠券',
      subtitle: '6 张待用',
      tag: '2 张将过期',
      icon: Icons.confirmation_num_outlined,
      color: AppColors.quickActionCoupon,
    ),
    _QuickActionData(
      title: '收货地址',
      subtitle: '3 个地址',
      tag: '默认已同步',
      icon: Icons.location_on_outlined,
      color: AppColors.quickActionAddress,
    ),
    _QuickActionData(
      title: '分享有礼',
      subtitle: '邀请赚积分',
      tag: '本周推荐',
      icon: Icons.ios_share_outlined,
      color: AppColors.quickActionShare,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MySectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const MySectionHeader(
            title: '常用功能',
            subtitle: '保留高频入口，减少不必要的视觉打断。',
            trailing: '更多',
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double itemWidth = calculateMySectionItemWidth(constraints);

              return Wrap(
                spacing: kMySectionItemSpacing,
                runSpacing: kMySectionItemSpacing,
                children: _actions.map((_QuickActionData action) {
                  return SizedBox(
                    width: itemWidth,
                    child: _QuickActionTile(action: action),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final _QuickActionData action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceMuted,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(action.icon, size: 19, color: action.color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      action.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        action.tag,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: action.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
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

class _QuickActionData {
  const _QuickActionData({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String tag;
  final IconData icon;
  final Color color;
}
