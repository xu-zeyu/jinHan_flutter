import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../models/business_page_model.dart';
import '../providers/business_page_provider.dart';
import 'business_merchant_card_widget.dart';

/// 商家列表模块，展示当前地区和排序下的完整商家卡片。
class BusinessMerchantListWidget extends StatelessWidget {
  const BusinessMerchantListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BusinessPageProvider provider = context.watch<BusinessPageProvider>();
    final List<BusinessMerchantModel> merchants = provider.merchants;

    if (merchants.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.sm + AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.storefront_rounded,
              color: AppColors.textSecondary,
              size: AppSpacing.xl + AppSpacing.sm,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${provider.selectedRegion.name} 暂无商家',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppSpacing.md,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              '请切换其他地区查看可交易商家',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppSpacing.sm,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        for (int index = 0; index < merchants.length; index++) ...<Widget>[
          BusinessMerchantCardWidget(merchant: merchants[index]),
          if (index != merchants.length - 1)
            const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        ],
      ],
    );
  }
}
