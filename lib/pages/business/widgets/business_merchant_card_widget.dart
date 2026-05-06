import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../models/business_page_model.dart';
import 'business_merchant_avatar_widget.dart';
import 'business_merchant_preview_tile_widget.dart';

/// 商家卡片组件，展示商家核心信息和三个商品预览。
class BusinessMerchantCardWidget extends StatelessWidget {
  const BusinessMerchantCardWidget({
    super.key,
    required this.merchant,
  });

  final BusinessMerchantModel merchant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppSpacing.md,
            offset: Offset(0, AppSpacing.xs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _MerchantSummary(merchant: merchant),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          Row(
            children: <Widget>[
              for (int index = 0;
                  index < merchant.products.length;
                  index++) ...<Widget>[
                Expanded(
                  child: BusinessMerchantPreviewTileWidget(
                    product: merchant.products[index],
                    seed: merchant.code.hashCode.abs() + index,
                  ),
                ),
                if (index != merchant.products.length - 1)
                  const SizedBox(width: AppSpacing.xs),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MerchantSummary extends StatelessWidget {
  const _MerchantSummary({
    required this.merchant,
  });

  final BusinessMerchantModel merchant;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BusinessMerchantAvatarWidget(
          merchant: merchant,
          size: AppSpacing.xl + AppSpacing.md,
          badgeLabel: merchant.levelLabel,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                merchant.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: AppSpacing.md,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                merchant.cityLabel,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppSpacing.sm,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              _MerchantMetricsLine(merchant: merchant),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        _MerchantTradePanel(transactionCount: merchant.transactionCount),
      ],
    );
  }
}

class _MerchantMetricsLine extends StatelessWidget {
  const _MerchantMetricsLine({
    required this.merchant,
  });

  final BusinessMerchantModel merchant;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle =
        Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.textSecondary,
              fontSize: AppSpacing.sm,
              fontWeight: FontWeight.w500,
            );
    final TextStyle highlightStyle = baseStyle.copyWith(
      color: AppColors.orderPending,
      fontWeight: FontWeight.w800,
    );

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: <InlineSpan>[
          const TextSpan(text: '在售 '),
          TextSpan(text: '${merchant.onSaleCount} 只', style: highlightStyle),
          const TextSpan(text: ' | 好评 '),
          TextSpan(text: '${merchant.reviewCount} 条', style: highlightStyle),
          const TextSpan(text: ' | 等级 '),
          TextSpan(
            text: '${_formatRating(merchant.rating)} 星',
            style: highlightStyle,
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _formatRating(double rating) {
    if (rating == rating.truncateToDouble()) {
      return rating.toStringAsFixed(0);
    }
    return rating.toStringAsFixed(1);
  }
}

class _MerchantTradePanel extends StatelessWidget {
  const _MerchantTradePanel({
    required this.transactionCount,
  });

  final int transactionCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.xl + AppSpacing.md,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.xl + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$transactionCount',
              style: const TextStyle(
                color: AppColors.orderPending,
                fontSize: AppSpacing.md,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            '担保交易',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSpacing.sm,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
