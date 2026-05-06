import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../models/business_page_model.dart';

/// 商家商品预览卡片，用于模拟参考图中的宠物缩略图区域。
class BusinessMerchantPreviewTileWidget extends StatelessWidget {
  const BusinessMerchantPreviewTileWidget({
    super.key,
    required this.product,
    required this.seed,
  });

  final BusinessProductModel product;
  final int seed;

  @override
  Widget build(BuildContext context) {
    final _PreviewPalette palette =
        _previewPalettes[seed % _previewPalettes.length];
    final IconData icon = _previewIcons[seed % _previewIcons.length];

    return AspectRatio(
      aspectRatio: AppSpacing.lg / AppSpacing.xl,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.md),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[palette.top, palette.bottom],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Text(
                  product.tag,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: AppSpacing.sm,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              right: -AppSpacing.xs,
              child: Container(
                width: AppSpacing.xl + AppSpacing.md,
                height: AppSpacing.xl + AppSpacing.md,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Align(
              child: Icon(
                icon,
                size: AppSpacing.xl + AppSpacing.md,
                color: AppColors.surface.withValues(alpha: 0.92),
              ),
            ),
            Positioned(
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              bottom: AppSpacing.xs,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.surface,
                      fontSize: AppSpacing.sm,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    product.priceLabel,
                    style: const TextStyle(
                      color: AppColors.surface,
                      fontSize: AppSpacing.sm,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewPalette {
  const _PreviewPalette({
    required this.top,
    required this.bottom,
  });

  final Color top;
  final Color bottom;
}

const List<_PreviewPalette> _previewPalettes = <_PreviewPalette>[
  _PreviewPalette(
    top: AppColors.headerGradientMid1,
    bottom: AppColors.headerGradientMid2,
  ),
  _PreviewPalette(
    top: AppColors.headerGradientStart,
    bottom: AppColors.headerGradientMid1,
  ),
  _PreviewPalette(
    top: AppColors.headerGradientEnd,
    bottom: AppColors.headerGradientMid2,
  ),
  _PreviewPalette(
    top: AppColors.headerGradientMid2,
    bottom: AppColors.headerGradientEnd,
  ),
];

const List<IconData> _previewIcons = <IconData>[
  Icons.pets_rounded,
  Icons.favorite_rounded,
  Icons.flutter_dash_rounded,
  Icons.auto_awesome_rounded,
];
