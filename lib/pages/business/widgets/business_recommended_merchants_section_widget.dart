import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../models/business_page_model.dart';
import '../providers/business_page_provider.dart';
import 'business_merchant_avatar_widget.dart';
import 'business_section_shell_widget.dart';

/// 推荐商家模块，按四列宫格展示优选商家。
class BusinessRecommendedMerchantsSectionWidget extends StatelessWidget {
  const BusinessRecommendedMerchantsSectionWidget({super.key});

  static const int _columnCount = 4;
  static const double _avatarSize = AppSpacing.xl + AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    final List<BusinessMerchantModel> merchants =
        context.watch<BusinessPageProvider>().recommendedMerchants;

    return BusinessSectionShellWidget(
      title: '推荐商家',
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double itemWidth = _calculateItemWidth(constraints.maxWidth);

          return Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm + AppSpacing.xs,
            children: <Widget>[
              for (final BusinessMerchantModel merchant in merchants.take(8))
                SizedBox(
                  width: itemWidth,
                  child: _RecommendedMerchantCard(merchant: merchant),
                ),
            ],
          );
        },
      ),
    );
  }

  double _calculateItemWidth(double maxWidth) {
    final double spacing =
        AppSpacing.sm * (_columnCount - 1) / _columnCount.toDouble();
    return (maxWidth / _columnCount) - spacing;
  }
}

class _RecommendedMerchantCard extends StatelessWidget {
  const _RecommendedMerchantCard({
    required this.merchant,
  });

  final BusinessMerchantModel merchant;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BusinessMerchantAvatarWidget(
          merchant: merchant,
          size: BusinessRecommendedMerchantsSectionWidget._avatarSize,
          badgeLabel: merchant.levelLabel,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          merchant.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppSpacing.sm,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          merchant.cityLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppSpacing.sm,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
