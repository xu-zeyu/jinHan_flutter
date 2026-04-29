import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';
import 'widgets/account_overview_card.dart';
import 'widgets/boarding_section.dart';
import 'widgets/coupon_section.dart';
import 'widgets/my_section_shell.dart';
import 'widgets/pet_section.dart';
import 'widgets/theme_selector_sheet.dart';

enum SettingAction {
  none,
  theme,
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static const double _expandedHeaderHeight = 208;
  static const double _horizontalPadding = 16;
  static const double _maxHeaderStretchOffset = 88;

  final List<_QuickActionData> _quickActions = const <_QuickActionData>[
    _QuickActionData(
      title: '专属客服',
      subtitle: '1v1 服务',
      assetName: 'assets/images/ic_customer_service.svg',
      tint: AppColors.quickActionCustomerService,
    ),
    _QuickActionData(
      title: '优惠券',
      subtitle: '6 张待用',
      assetName: 'assets/images/ic_coupon.svg',
      tint: AppColors.quickActionCoupon,
    ),
    _QuickActionData(
      title: '收货地址',
      subtitle: '3 个地址',
      assetName: 'assets/images/ic_address.svg',
      tint: AppColors.quickActionAddress,
    ),
    _QuickActionData(
      title: '分享有礼',
      subtitle: '邀请赚积分',
      assetName: 'assets/images/share.svg',
      tint: AppColors.quickActionShare,
    ),
  ];

  final List<_OrderStatusData> _orderStatuses = const <_OrderStatusData>[
    _OrderStatusData(
      title: '待付款',
      assetName: 'assets/images/ic_order_pending_payment.svg',
      count: 2,
      tint: AppColors.orderPending,
    ),
    _OrderStatusData(
      title: '待发货',
      assetName: 'assets/images/ic_order_pending_shipment.svg',
      count: 1,
      tint: AppColors.orderShipping,
    ),
    _OrderStatusData(
      title: '待收货',
      assetName: 'assets/images/ic_order_pending_receipt.svg',
      count: 4,
      tint: AppColors.orderReceiving,
    ),
    _OrderStatusData(
      title: '已完成',
      assetName: 'assets/images/ic_order_completed.svg',
      count: 12,
      tint: AppColors.orderCompleted,
    ),
  ];

  final List<_SettingItemData> _settings = const <_SettingItemData>[
    _SettingItemData(
      title: '主题外观',
      subtitle: '浅色 / 深色 / 金色',
      icon: Icons.palette_outlined,
      action: SettingAction.theme,
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

  late final AnimationController _entranceController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          physics: const _LimitedTopStretchPhysics(
            maxTopOverscroll: _maxHeaderStretchOffset,
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              stretch: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: const Color(0xFFF7F3E8),
              surfaceTintColor: Colors.transparent,
              expandedHeight: _expandedHeaderHeight,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _NavIconButton(
                    icon: Icons.settings_outlined,
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ThemeSelectorSheet(),
                      );
                    },
                  ),
                ),
              ],
              flexibleSpace: const FlexibleSpaceBar(
                centerTitle: false,
                collapseMode: CollapseMode.pin,
                expandedTitleScale: 1,
                titlePadding: EdgeInsetsDirectional.only(
                  start: 16,
                  end: 56,
                  bottom: 12,
                ),
                stretchModes: <StretchMode>[
                  StretchMode.zoomBackground,
                ],
                title: _FlexibleHeaderTitle(),
                background: _HeaderPanel(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                _horizontalPadding,
                12,
                _horizontalPadding,
                112,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    // 账户概览卡片（余额、积分、收藏、本月消费）
                    _buildAnimatedEntry(
                      index: 0,
                      child: const AccountOverviewCard(),
                    ),
                    const SizedBox(height: 12),
                    // 优惠券模块
                    _buildAnimatedEntry(
                      index: 1,
                      child: const CouponSection(),
                    ),
                    const SizedBox(height: 12),
                    // 爱宠模块
                    _buildAnimatedEntry(
                      index: 2,
                      child: const PetSection(),
                    ),
                    const SizedBox(height: 12),
                    // 寄养服务模块
                    _buildAnimatedEntry(
                      index: 3,
                      child: const BoardingSection(),
                    ),
                    const SizedBox(height: 12),
                    // 常用功能
                    _buildAnimatedEntry(
                      index: 4,
                      child: MySectionCard(
                        child: Column(
                          children: <Widget>[
                            const MySectionHeader(
                              title: '常用功能',
                              trailing: '全部',
                            ),
                            const SizedBox(height: 12),
                            _QuickActionGrid(actions: _quickActions),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 我的订单
                    _buildAnimatedEntry(
                      index: 5,
                      child: MySectionCard(
                        child: Column(
                          children: <Widget>[
                            const MySectionHeader(
                              title: '我的订单',
                              trailing: '查看全部',
                            ),
                            const SizedBox(height: 12),
                            _OrderStatusRow(statuses: _orderStatuses),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 设置列表
                    _buildAnimatedEntry(
                      index: 6,
                      child: MySectionCard(
                        padding: EdgeInsets.zero,
                        child: _SettingsList(items: _settings),
                      ),
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

  Widget _buildAnimatedEntry({
    required int index,
    required Widget child,
  }) {
    final double start = (index * 0.08).clamp(0, 0.3).toDouble();
    final Animation<double> animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (BuildContext context, Widget? animatedChild) {
        final double value = animation.value;
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, lerpDouble(18, 0, value)!),
            child: animatedChild,
          ),
        );
      },
    );
  }
}

class _HeaderPanel extends StatelessWidget {
  const _HeaderPanel();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF5E5BA),
            Color(0xFFF8F3E8),
          ],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

class _FlexibleHeaderTitle extends StatelessWidget {
  const _FlexibleHeaderTitle();

  @override
  Widget build(BuildContext context) {
    final FlexibleSpaceBarSettings settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
    final double deltaExtent = settings.maxExtent - settings.minExtent;
    final double collapseT = deltaExtent == 0
        ? 1
        : (1 - (settings.currentExtent - settings.minExtent) / deltaExtent)
            .clamp(0.0, 1.0)
            .toDouble();
    final double avatarSize = lerpDouble(60, 32, collapseT)!;
    final double titleSize = lerpDouble(20, 16, collapseT)!;
    final double spacing = lerpDouble(12, 10, collapseT)!;
    final double detailsFactor = (1 - collapseT / 0.72).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _HeroAvatar(size: avatarSize),
                  SizedBox(width: spacing),
                  Expanded(
                    child: SizedBox(
                      height: avatarSize,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'JinHan 用户',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (detailsFactor > 0.1)
                            Opacity(
                              opacity: detailsFactor,
                              child: Text(
                                '普通会员  ·  账号状态正常',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: titleSize - 8,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.topLeft,
                  heightFactor: detailsFactor,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: _HeaderMetricsCard(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _HeroAvatar extends StatelessWidget {
  const _HeroAvatar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.05),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/app_icon.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _HeaderMetricsCard extends StatelessWidget {
  const _HeaderMetricsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: <Widget>[
          Expanded(
            child: _HeaderMetric(
              value: '1,286',
              label: '余额',
            ),
          ),
          Expanded(
            child: _HeaderMetric(
              value: '342',
              label: '积分',
            ),
          ),
          Expanded(
            child: _HeaderMetric(
              value: '12',
              label: '收藏',
            ),
          ),
        ],
      ),
    );
  }
}

class _LimitedTopStretchPhysics extends BouncingScrollPhysics {
  const _LimitedTopStretchPhysics({
    required this.maxTopOverscroll,
    super.parent,
  });

  final double maxTopOverscroll;

  @override
  _LimitedTopStretchPhysics applyTo(ScrollPhysics? ancestor) {
    return _LimitedTopStretchPhysics(
      maxTopOverscroll: maxTopOverscroll,
      parent: buildParent(ancestor),
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    final double minAllowed = position.minScrollExtent - maxTopOverscroll;
    if (value < minAllowed) {
      if (position.pixels <= minAllowed) {
        return value - position.pixels;
      }
      return value - minAllowed;
    }
    return super.applyBoundaryConditions(position, value);
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  const _QuickActionGrid({required this.actions});

  final List<_QuickActionData> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double spacing = 10;
        final bool singleColumn = constraints.maxWidth < 350;
        final double itemWidth = singleColumn
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: actions.map((_QuickActionData action) {
            return SizedBox(
              width: itemWidth,
              child: _QuickActionTile(action: action),
            );
          }).toList(),
        );
      },
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: action.tint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    action.assetName,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      action.tint,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      action.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      action.subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
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

class _OrderStatusRow extends StatelessWidget {
  const _OrderStatusRow({required this.statuses});

  final List<_OrderStatusData> statuses;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: statuses
          .map(
            (_OrderStatusData item) => Expanded(
              child: _OrderStatusTile(item: item),
            ),
          )
          .toList(),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Column(
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: item.tint.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        item.assetName,
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          item.tint,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  if (item.count > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: item.tint,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${item.count}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  const _SettingsList({required this.items});

  final List<_SettingItemData> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(items.length, (int index) {
        final _SettingItemData item = items[index];
        return Column(
          children: <Widget>[
            _SettingsTile(item: item),
            if (index != items.length - 1)
              const Divider(
                height: 1,
                indent: 56,
                endIndent: 14,
                color: AppColors.border,
              ),
          ],
        );
      }),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.item});

  final _SettingItemData item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (item.action == SettingAction.theme) {
            showModalBottomSheet<void>(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) => const ThemeSelectorSheet(),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
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
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
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

class _QuickActionData {
  const _QuickActionData({
    required this.title,
    required this.subtitle,
    required this.assetName,
    required this.tint,
  });

  final String title;
  final String subtitle;
  final String assetName;
  final Color tint;
}

class _OrderStatusData {
  const _OrderStatusData({
    required this.title,
    required this.assetName,
    required this.count,
    required this.tint,
  });

  final String title;
  final String assetName;
  final int count;
  final Color tint;
}

class _SettingItemData {
  const _SettingItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.action = SettingAction.none,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final SettingAction action;
}
