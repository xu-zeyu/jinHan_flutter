import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'my_section_shell.dart';

class CouponSection extends StatelessWidget {
  const CouponSection({super.key});

  static const List<_CouponData> _coupons = <_CouponData>[
    _CouponData(
      title: '洗护通用券',
      amount: '￥60',
      condition: '满 299 可用',
      expireDate: '05.18',
      accent: Color(0xFFE58C68),
      highlight: '今日可叠加',
    ),
    _CouponData(
      title: '主粮折扣券',
      amount: '8.8折',
      condition: '指定品牌可用',
      expireDate: '05.12',
      accent: Color(0xFFD3A64A),
      highlight: '库存紧张',
    ),
    _CouponData(
      title: '寄养体验券',
      amount: '￥120',
      condition: '周末寄养减免',
      expireDate: '05.31',
      accent: Color(0xFF6B9E7F),
      highlight: '新客专享',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MySectionCard(
      child: Column(
        children: <Widget>[
          const MySectionHeader(
            title: '优惠券优化',
            subtitle: '3 张建议优先使用，避免本周过期',
            trailing: '查看全部',
          ),
          const SizedBox(height: 14),
          const _CouponHeroCard(),
          const SizedBox(height: 12),
          Column(
            children: _coupons
                .map(
                  (_CouponData coupon) => Padding(
                    padding: EdgeInsets.only(
                      bottom: coupon == _coupons.last ? 0 : 10,
                    ),
                    child: _CouponTicket(coupon: coupon),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CouponHeroCard extends StatelessWidget {
  const _CouponHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFFEF4E1),
            Color(0xFFF9E1B3),
            Color(0xFFFFF8EA),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '待使用 6 张',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '本月预计可节省 ￥248，优先消耗高面额券。',
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
          SizedBox(width: 12),
          _CouponHeroTag(
            label: '2 张即将过期',
            icon: Icons.local_fire_department_rounded,
          ),
        ],
      ),
    );
  }
}

class _CouponHeroTag extends StatelessWidget {
  const _CouponHeroTag({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: AppColors.danger),
          const SizedBox(height: 4),
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

class _CouponTicket extends StatelessWidget {
  const _CouponTicket({required this.coupon});

  final _CouponData coupon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: coupon.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: coupon.accent.withValues(alpha: 0.18)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Container(
              width: 92,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              decoration: BoxDecoration(
                color: coupon.accent.withValues(alpha: 0.16),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    coupon.amount,
                    style: TextStyle(
                      color: coupon.accent,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coupon.highlight,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            coupon.title,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
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
                            '至 ${coupon.expireDate}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      coupon.condition,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.bolt_rounded,
                          size: 14,
                          color: coupon.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '推荐在结算页自动勾选',
                          style: TextStyle(
                            color: coupon.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponData {
  const _CouponData({
    required this.title,
    required this.amount,
    required this.condition,
    required this.expireDate,
    required this.accent,
    required this.highlight,
  });

  final String title;
  final String amount;
  final String condition;
  final String expireDate;
  final Color accent;
  final String highlight;
}
