import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'my_section_shell.dart';

class AccountOverviewCard extends StatelessWidget {
  const AccountOverviewCard({super.key});

  static const List<_AccountMetricData> _metrics = <_AccountMetricData>[
    _AccountMetricData(
      label: '余额',
      value: '￥1,280.50',
      note: '可直接抵扣',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFFE07A5F),
    ),
    _AccountMetricData(
      label: '积分',
      value: '3,240',
      note: '本月 +320',
      icon: Icons.stars_rounded,
      color: Color(0xFFD9A441),
    ),
    _AccountMetricData(
      label: '收藏',
      value: '28',
      note: '3 件降价提醒',
      icon: Icons.favorite_rounded,
      color: Color(0xFFD16D8A),
    ),
    _AccountMetricData(
      label: '本月消费',
      value: '￥2,460',
      note: '较上月 +18%',
      icon: Icons.shopping_bag_rounded,
      color: Color(0xFF5E9C76),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MySectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFFFFF3D6),
                  Color(0xFFF8E2B5),
                  Color(0xFFF7EBDD),
                ],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '账户概览',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _AccountTag(
                      icon: Icons.workspace_premium_rounded,
                      label: '会员升级中',
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '本月累计获得 3 张券，建议优先使用余额和积分组合抵扣。',
                  style: TextStyle(
                    color: AppColors.vipTextMedium,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              children: <Widget>[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _metrics.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.34,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return _AccountMetricCard(metric: _metrics[index]);
                  },
                ),
                const SizedBox(height: 12),
                const Row(
                  children: <Widget>[
                    Expanded(
                      child: _SummaryPill(
                        title: '支付建议',
                        value: '余额优先',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _SummaryPill(
                        title: '消费热度',
                        value: '活跃',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountTag extends StatelessWidget {
  const _AccountTag({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.badgeGold.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.vipTextDark,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountMetricCard extends StatelessWidget {
  const _AccountMetricCard({required this.metric});

  final _AccountMetricData metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: metric.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: metric.color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  metric.color.withValues(alpha: 0.2),
                  metric.color.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(metric.icon, color: metric.color, size: 22),
          ),
          const Spacer(),
          Text(
            metric.label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.value,
            style: TextStyle(
              color: metric.color,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.note,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountMetricData {
  const _AccountMetricData({
    required this.label,
    required this.value,
    required this.note,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String note;
  final IconData icon;
  final Color color;
}
