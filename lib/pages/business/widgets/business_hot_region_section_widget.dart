import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../models/business_page_model.dart';
import '../providers/business_page_provider.dart';
import 'business_section_shell_widget.dart';

/// 热门地区模块，支持基于地区编码切换当前商家区域。
class BusinessHotRegionSectionWidget extends StatelessWidget {
  const BusinessHotRegionSectionWidget({super.key});

  static const int _gridColumnCount = 4;
  static const int _sheetColumnCount = 3;
  static const double _chipHeight = AppSpacing.lg + AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    final BusinessPageProvider provider = context.watch<BusinessPageProvider>();

    return BusinessSectionShellWidget(
      title: '热门地区',
      trailing: _MoreRegionButton(onTap: () => _showRegionSheet(context)),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double chipWidth = _calculateChipWidth(
            maxWidth: constraints.maxWidth,
            columnCount: _gridColumnCount,
          );

          return Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final BusinessRegionModel region in provider.hotRegions)
                SizedBox(
                  width: chipWidth,
                  child: _RegionChoiceChip(
                    region: region,
                    isCurrent: region.code == provider.currentRegionCode,
                    isSelected: region.code == provider.selectedRegionCode,
                    onTap: () => provider.selectRegion(region.code),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showRegionSheet(BuildContext context) {
    final BusinessPageProvider provider = context.read<BusinessPageProvider>();

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return ChangeNotifierProvider<BusinessPageProvider>.value(
          value: provider,
          child: SafeArea(
            top: false,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.lg),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm + AppSpacing.xs,
                  AppSpacing.sm + AppSpacing.xs,
                  AppSpacing.sm + AppSpacing.xs,
                  AppSpacing.md,
                ),
                child: Consumer<BusinessPageProvider>(
                  builder: (_, BusinessPageProvider value, __) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const _SheetHandle(),
                        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                        Text(
                          '更多地区',
                          style: Theme.of(modalContext)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontSize: AppSpacing.md,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          '切换后推荐商家与列表会同步更新',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppSpacing.sm + AppSpacing.xs,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                        LayoutBuilder(
                          builder: (
                            BuildContext context,
                            BoxConstraints constraints,
                          ) {
                            final double chipWidth = _calculateChipWidth(
                              maxWidth: constraints.maxWidth,
                              columnCount: _sheetColumnCount,
                            );

                            return Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
                              children: <Widget>[
                                for (final BusinessRegionModel region
                                    in value.allRegions)
                                  SizedBox(
                                    width: chipWidth,
                                    child: _RegionChoiceChip(
                                      region: region,
                                      isCurrent: region.code ==
                                          value.currentRegionCode,
                                      isSelected: region.code ==
                                          value.selectedRegionCode,
                                      onTap: () {
                                        value.selectRegion(region.code);
                                        Navigator.of(modalContext).pop();
                                      },
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static double _calculateChipWidth({
    required double maxWidth,
    required int columnCount,
  }) {
    final double spacing =
        AppSpacing.sm * (columnCount - 1) / columnCount.toDouble();
    return (maxWidth / columnCount) - spacing;
  }
}

class _MoreRegionButton extends StatelessWidget {
  const _MoreRegionButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '更多地区',
            style: TextStyle(
              fontSize: AppSpacing.sm,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.chevron_right_rounded,
            size: AppSpacing.md,
          ),
        ],
      ),
    );
  }
}

class _RegionChoiceChip extends StatelessWidget {
  const _RegionChoiceChip({
    required this.region,
    required this.isCurrent,
    required this.isSelected,
    required this.onTap,
  });

  final BusinessRegionModel region;
  final bool isCurrent;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: Container(
          height: BusinessHotRegionSectionWidget._chipHeight,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (isCurrent) ...<Widget>[
                const Icon(
                  Icons.location_on_rounded,
                  size: AppSpacing.md,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  region.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppSpacing.sm,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppSpacing.xl + AppSpacing.lg,
        height: AppSpacing.xs,
        decoration: BoxDecoration(
          color: AppColors.borderStrong,
          borderRadius: BorderRadius.circular(AppSpacing.xs),
        ),
      ),
    );
  }
}
