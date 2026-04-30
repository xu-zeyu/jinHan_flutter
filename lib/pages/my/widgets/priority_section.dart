import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'my_section_shell.dart';
import 'responsive_wrap.dart';

class PrioritySection extends StatelessWidget {
  const PrioritySection({super.key});

  static const List<_OrderStatusData> _statuses = <_OrderStatusData>[
    _OrderStatusData(
      title: '待付款',
      count: 2,
      icon: Icons.payments_outlined,
      color: AppColors.orderPending,
    ),
    _OrderStatusData(
      title: '待发货',
      count: 1,
      icon: Icons.inventory_2_outlined,
      color: AppColors.orderShipping,
    ),
    _OrderStatusData(
      title: '待收货',
      count: 4,
      icon: Icons.local_shipping_outlined,
      color: AppColors.orderReceiving,
    ),
    _OrderStatusData(
      title: '已完成',
      count: 12,
      icon: Icons.check_circle_outline_rounded,
      color: AppColors.orderCompleted,
    ),
  ];

  static const List<_ReminderData> _reminders = <_ReminderData>[
    _ReminderData(
      label: '2 笔待付款需确认',
      icon: Icons.payments_outlined,
      color: AppColors.orderPending,
    ),
    _ReminderData(
      label: '2 单配送中',
      icon: Icons.local_shipping_outlined,
      color: AppColors.orderReceiving,
    ),
    _ReminderData(
      label: '1 单售后处理中',
      icon: Icons.support_agent_rounded,
      color: AppColors.quickActionCustomerService,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MySectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const MySectionHeader(
            title: '订单中心',
            subtitle: '把最影响下单和履约体验的信息前置。',
            trailing: '全部订单',
          ),
          const SizedBox(height: 14),
          const _PriorityBanner(),
          const SizedBox(height: 12),
          const _OrderStatusGrid(statuses: _statuses),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _reminders.map((_ReminderData item) {
              return _ReminderChip(item: item);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PriorityBanner extends StatelessWidget {
  const _PriorityBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '本周订单动态 4 项',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _PriorityTag(label: '高优先'),
            ],
          ),
          SizedBox(height: 6),
          Text(
            '待支付、配送和售后进度集中展示，减少在多个模块之间重复切换查询。',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _BannerStat(label: '待付款', value: '2'),
              _BannerStat(label: '配送中', value: '2'),
              _BannerStat(label: '售后中', value: '1'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriorityTag extends StatelessWidget {
  const _PriorityTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceAccent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BannerStat extends StatelessWidget {
  const _BannerStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderStatusGrid extends StatelessWidget {
  const _OrderStatusGrid({required this.statuses});

  final List<_OrderStatusData> statuses;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double itemWidth = calculateMySectionItemWidth(constraints);

        return Wrap(
          spacing: kMySectionItemSpacing,
          runSpacing: kMySectionItemSpacing,
          children: statuses.map((_OrderStatusData status) {
            return SizedBox(
              width: itemWidth,
              child: _OrderStatusTile(item: status),
            );
          }).toList(),
        );
      },
    );
  }
}

class _OrderStatusTile extends StatelessWidget {
  const _OrderStatusTile({required this.item});

  final _OrderStatusData item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: item.color.withValues(alpha: 0.18)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 18, color: item.color),
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
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.count} 笔',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: item.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
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

class _ReminderChip extends StatelessWidget {
  const _ReminderChip({required this.item});

  final _ReminderData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(item.icon, size: 14, color: item.color),
          const SizedBox(width: 6),
          Text(
            item.label,
            style: TextStyle(
              color: item.color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderStatusData {
  const _OrderStatusData({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;
}

class _ReminderData {
  const _ReminderData({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}
