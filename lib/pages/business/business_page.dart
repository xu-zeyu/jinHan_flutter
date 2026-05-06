import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import 'providers/business_page_provider.dart';
import 'widgets/business_filter_tabs_widget.dart';
import 'widgets/business_hot_region_section_widget.dart';
import 'widgets/business_merchant_list_widget.dart';
import 'widgets/business_nav_bar_widget.dart';
import 'widgets/business_recommended_merchants_section_widget.dart';

/// 商家页面，负责装配顶部导航、地区筛选、推荐商家与商家列表。
class BusinessPage extends StatelessWidget {
  const BusinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BusinessPageProvider>(
      create: (_) => BusinessPageProvider()..initialize(),
      child: const _BusinessPageView(),
    );
  }
}

class _BusinessPageView extends StatelessWidget {
  const _BusinessPageView();

  static const double _navBarHeight = AppSpacing.xl;
  static const double _stickyTabsHeight = BusinessFilterTabsWidget.headerHeight;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.contentBackground,
      ),
      child: const Scaffold(
        backgroundColor: AppColors.contentBackground,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: AppColors.surface,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: _navBarHeight,
              title: BusinessNavBarWidget(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.sm + AppSpacing.xs,
                  AppSpacing.sm + AppSpacing.xs,
                  AppSpacing.sm + AppSpacing.xs,
                  AppSpacing.sm,
                ),
                child: Column(
                  children: <Widget>[
                    BusinessHotRegionSectionWidget(),
                    SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                    BusinessRecommendedMerchantsSectionWidget(),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _BusinessStickyHeaderDelegate(
                height: _stickyTabsHeight,
                child: ColoredBox(
                  color: AppColors.contentBackground,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.sm + AppSpacing.xs,
                      AppSpacing.xs,
                      AppSpacing.sm + AppSpacing.xs,
                      AppSpacing.sm,
                    ),
                    child: BusinessFilterTabsWidget(),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.sm + AppSpacing.xs,
                  AppSpacing.xs,
                  AppSpacing.sm + AppSpacing.xs,
                  AppSpacing.xl + AppSpacing.xl + AppSpacing.lg,
                ),
                child: BusinessMerchantListWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _BusinessStickyHeaderDelegate({
    required this.height,
    required this.child,
  });

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: height,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _BusinessStickyHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
