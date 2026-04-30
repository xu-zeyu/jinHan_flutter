import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/api/user_repository.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/storage/token_manager.dart';
import '../../shared/models/user_models.dart';
import 'providers/my_page_provider.dart';
import 'widgets/my_page_body.dart';
import 'widgets/theme_selector_sheet.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static const double _expandedHeaderHeight = 208;
  static const double _maxHeaderStretchOffset = 88;

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

  void _showThemeSelector() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const ThemeSelectorSheet(),
    );
  }

  void _goToLogin() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ChangeNotifierProvider<MyPageProvider>(
      create: (BuildContext context) => MyPageProvider(
        userRepository: context.read<UserRepository>(),
        tokenManager: context.read<TokenManager>(),
      )..initialize(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                backgroundColor: AppColors.surfaceAccent,
                surfaceTintColor: Colors.transparent,
                expandedHeight: _expandedHeaderHeight,
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm + 4),
                    child: _NavIconButton(
                      icon: Icons.settings_outlined,
                      onTap: _showThemeSelector,
                    ),
                  ),
                ],
                flexibleSpace: const FlexibleSpaceBar(
                  centerTitle: false,
                  collapseMode: CollapseMode.pin,
                  expandedTitleScale: 1,
                  titlePadding: EdgeInsetsDirectional.only(
                    start: AppSpacing.md,
                    end: AppSpacing.xl + AppSpacing.lg,
                    bottom: AppSpacing.sm + 4,
                  ),
                  stretchModes: <StretchMode>[
                    StretchMode.zoomBackground,
                  ],
                  title: _FlexibleHeaderTitle(),
                  background: _HeaderPanel(),
                ),
              ),
              SliverToBoxAdapter(
                child: MyPageBody(
                  entranceController: _entranceController,
                  onThemeTap: _showThemeSelector,
                  onLoginTap: _goToLogin,
                ),
              ),
            ],
          ),
        ),
      ),
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
            AppColors.surfaceAccent,
            AppColors.background,
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
    final MyPageProvider provider = context.watch<MyPageProvider>();
    final UserProfileModel? profile = provider.profile;
    final String title =
        profile?.displayName ?? (provider.isLoggedIn ? '我的档案' : '未登录');
    final String subtitle = _buildSubtitle(provider, profile);
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
                  _HeroAvatar(
                    size: avatarSize,
                    title: title,
                    isLoggedIn: provider.isLoggedIn,
                  ),
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
                            title,
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
                                subtitle,
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm + 4),
                    child: _HeaderMetricsCard(provider: provider),
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
  const _HeroAvatar({
    required this.size,
    required this.title,
    required this.isLoggedIn,
  });

  final double size;
  final String title;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: <Color>[
            AppColors.avatarGradientStart,
            AppColors.avatarGradientMid,
            AppColors.avatarGradientEnd,
          ],
        ),
      ),
      child: Center(
        child: isLoggedIn
            ? Text(
                title.characters.first.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.34,
                  fontWeight: FontWeight.w800,
                ),
              )
            : Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: size * 0.46,
              ),
      ),
    );
  }
}

String _buildSubtitle(
  MyPageProvider provider,
  UserProfileModel? profile,
) {
  if (!provider.isLoggedIn) {
    return '点击登录后查看完整用户与宠物资料';
  }
  if (profile != null) {
    final String phone =
        profile.maskedPhone.isNotEmpty ? profile.maskedPhone : '手机号未完善';
    return '${profile.displayStatus}  ·  $phone';
  }
  if (provider.hasError) {
    return '资料加载失败，请重试';
  }
  return '正在同步用户资料';
}

class _HeaderMetricsCard extends StatelessWidget {
  const _HeaderMetricsCard({required this.provider});

  final MyPageProvider provider;

  @override
  Widget build(BuildContext context) {
    final UserProfileModel? profile = provider.profile;
    final bool isLoggedIn = provider.isLoggedIn;
    final String firstSummary = !isLoggedIn
        ? '登录后展示手机号、认证状态和最近登录信息'
        : profile == null
            ? '正在同步账户信息'
            : '${profile.displayStatus} · ${profile.maskedPhone.isNotEmpty ? profile.maskedPhone : '资料待完善'}';
    final String secondSummary = !isLoggedIn
        ? '登录后同步爱宠档案与基础资料'
        : profile == null
            ? '正在同步宠物资料'
            : profile.petCount == 0
                ? '暂无爱宠档案'
                : '${profile.petCount} 只爱宠 · 最近更新 ${_latestPetUpdate(profile)}';

    return Container(
      key: const Key('my_page_header_summary_card'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md - 2,
        vertical: AppSpacing.sm + 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _HeaderSummaryTile(
              icon: Icons.badge_outlined,
              title: '账户信息',
              summary: firstSummary,
              accent: AppColors.quickActionCoupon,
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: _HeaderSummaryTile(
              icon: Icons.pets_rounded,
              title: '宠物档案',
              summary: secondSummary,
              accent: AppColors.orderCompleted,
            ),
          ),
        ],
      ),
    );
  }
}

String _latestPetUpdate(UserProfileModel profile) {
  final DateTime? latest = profile.petList
      .map((UserPetModel item) => item.updatedTime ?? item.createdTime)
      .whereType<DateTime>()
      .fold<DateTime?>(null, (DateTime? previous, DateTime next) {
    if (previous == null || next.isAfter(previous)) {
      return next;
    }
    return previous;
  });

  if (latest == null) {
    return '暂无时间';
  }

  final String month = latest.month.toString().padLeft(2, '0');
  final String day = latest.day.toString().padLeft(2, '0');
  return '$month-$day';
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

class _HeaderSummaryTile extends StatelessWidget {
  const _HeaderSummaryTile({
    required this.icon,
    required this.title,
    required this.summary,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String summary;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
