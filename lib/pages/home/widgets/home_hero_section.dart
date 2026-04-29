import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/models/home_models.dart';
import 'home_image_widgets.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({
    super.key,
    required this.banners,
    required this.varieties,
    required this.navBarHeight,
  });

  final List<HomeBannerItem> banners;
  final List<HomeVarietyItem> varieties;
  final double navBarHeight;

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _HomeHeroSectionLayoutDelegate(
        navBarHeight: navBarHeight,
        varietyCount: varieties.length,
      ),
      children: [
        LayoutId(
          id: _HomeHeroSectionSlot.banner,
          child: _BannerSwiper(
            banners: banners,
            navBarHeight: navBarHeight,
          ),
        ),
        LayoutId(
          id: _HomeHeroSectionSlot.grid,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _HotVarietyGrid(
              varieties: varieties,
            ),
          ),
        ),
      ],
    );
  }
}

enum _HomeHeroSectionSlot { banner, grid }

class _HomeHeroSectionLayoutDelegate extends MultiChildLayoutDelegate {
  _HomeHeroSectionLayoutDelegate({
    required this.navBarHeight,
    required this.varietyCount,
  });

  final double navBarHeight;
  final int varietyCount;

  @override
  void performLayout(Size size) {
    final bannerSize = layoutChild(
      _HomeHeroSectionSlot.banner,
      BoxConstraints.tightFor(width: size.width),
    );

    layoutChild(
      _HomeHeroSectionSlot.grid,
      BoxConstraints.tightFor(width: size.width),
    );

    positionChild(_HomeHeroSectionSlot.banner, Offset.zero);
    positionChild(
      _HomeHeroSectionSlot.grid,
      Offset(0, bannerSize.height - navBarHeight),
    );
  }

  @override
  Size getSize(BoxConstraints constraints) {
    final width = constraints.hasBoundedWidth ? constraints.maxWidth : 0.0;
    final bannerHeight = 180 + navBarHeight;
    final gridHeight = _estimateGridHeight(width);
    final totalHeight = bannerHeight + gridHeight - navBarHeight;
    return constraints.constrain(Size(width, totalHeight));
  }

  double _estimateGridHeight(double width) {
    const horizontalPadding = 14.0 * 2;
    const contentPadding = 16.0 * 2;
    const itemSpacing = 8.0 * 3;
    const headerHeight = 24.0;
    const titleSpacing = 10.0;
    const imageHeight = 58.0;
    const labelSpacing = 6.0;
    const labelHeight = 16.0;
    const verticalPadding = 12.0 + 8.0;
    const rowSpacing = 12.0;

    final availableWidth = width - horizontalPadding - contentPadding;
    final canRenderGrid = availableWidth > itemSpacing;
    final crossAxisCount = canRenderGrid ? 4 : 1;
    const itemHeight = imageHeight + labelSpacing + labelHeight;
    final rowCount =
        crossAxisCount <= 0 ? 0 : (varietyCount / crossAxisCount).ceil();

    return verticalPadding +
        headerHeight +
        titleSpacing +
        (rowCount * itemHeight) +
        ((rowCount > 1 ? rowCount - 1 : 0) * rowSpacing);
  }

  @override
  bool shouldRelayout(covariant _HomeHeroSectionLayoutDelegate oldDelegate) {
    return navBarHeight != oldDelegate.navBarHeight ||
        varietyCount != oldDelegate.varietyCount;
  }
}

class _BannerSwiper extends StatelessWidget {
  const _BannerSwiper({
    required this.banners,
    required this.navBarHeight,
  });

  final List<HomeBannerItem> banners;

  final double navBarHeight;

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return Container(
        width: double.infinity,
        height: 180 + navBarHeight,
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(18),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 180 + navBarHeight,
      child: Swiper(
        itemCount: banners.length,
        autoplay: true,
        loop: true,
        duration: 300,
        autoplayDelay: 3000,
        pagination: null,
        itemBuilder: (context, index) {
          return HomeRemoteImage(
            imageUrl: banners[index].imageUrl,
            fit: BoxFit.cover,
            placeholderColor: AppColors.cardTint,
          );
        },
      ),
    );
  }
}

class _HotVarietyGrid extends StatelessWidget {
  const _HotVarietyGrid({
    required this.varieties,
  });

  final List<HomeVarietyItem> varieties;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(14);
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: AppColors.surface.withValues(alpha: 0.88),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.84),
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 24,
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '热门宠物',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Text(
                          '查看更多',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 2),
                        SvgPicture.asset(
                          'assets/images/btn_more_normal.svg',
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            AppColors.accent,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = (constraints.maxWidth - 24) / 4;
                  return Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: [
                      for (final item in varieties)
                        SizedBox(
                          width: itemWidth,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 66,
                                height: 66,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.border.withValues(
                                      alpha: 0.72,
                                    ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 58,
                                    height: 58,
                                    child: HomeRemoteImage(
                                      imageUrl: item.iconUrl,
                                      fit: BoxFit.cover,
                                      placeholderColor: AppColors.cardTint,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
