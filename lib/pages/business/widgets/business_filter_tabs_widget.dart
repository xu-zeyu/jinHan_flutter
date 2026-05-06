import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../models/business_page_model.dart';
import '../providers/business_page_provider.dart';

/// 商家筛选标签栏，负责切换平台优选、交易量和星级等排序。
class BusinessFilterTabsWidget extends StatelessWidget {
  const BusinessFilterTabsWidget({super.key});

  static const double _chipHeight = AppSpacing.lg + AppSpacing.sm;
  static const double headerHeight =
      _chipHeight + AppSpacing.xs + AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    final BusinessPageProvider provider = context.watch<BusinessPageProvider>();
    final List<BusinessFilterTabModel> tabs = provider.filterTabs;

    return Row(
      children: <Widget>[
        for (int index = 0; index < tabs.length; index++) ...<Widget>[
          Expanded(
            child: _FilterTabChip(
              label: tabs[index].label,
              isSelected: tabs[index].code == provider.selectedSortCode,
              onTap: () => provider.selectSort(tabs[index].code),
            ),
          ),
          if (index != tabs.length - 1) const SizedBox(width: AppSpacing.xs),
        ],
      ],
    );
  }
}

class _FilterTabChip extends StatelessWidget {
  const _FilterTabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: BusinessFilterTabsWidget._chipHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.md),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            boxShadow: isSelected
                ? const <BoxShadow>[
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: AppSpacing.sm + AppSpacing.xs,
                      offset: Offset(0, AppSpacing.xs / 2),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppSpacing.sm,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
