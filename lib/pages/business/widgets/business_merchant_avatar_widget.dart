import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../models/business_page_model.dart';

/// 商家头像组件，统一推荐商家与列表卡片的头像视觉。
class BusinessMerchantAvatarWidget extends StatelessWidget {
  const BusinessMerchantAvatarWidget({
    super.key,
    required this.merchant,
    required this.size,
    this.badgeLabel,
  });

  final BusinessMerchantModel merchant;
  final double size;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    final _AvatarPalette palette =
        _avatarPalettes[merchant.code.hashCode.abs() % _avatarPalettes.length];

    return SizedBox(
      width: size,
      height: size + (badgeLabel == null ? 0 : AppSpacing.md),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[palette.start, palette.end],
              ),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: AppSpacing.sm + AppSpacing.xs,
                  offset: Offset(0, AppSpacing.xs),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: Container(
                    width: size / 2.6,
                    height: size / 2.6,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: AppSpacing.xs,
                  bottom: AppSpacing.sm,
                  child: Container(
                    width: size / 3.2,
                    height: size / 3.2,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Text(
                  merchant.avatarLabel,
                  style: TextStyle(
                    color: AppColors.surface,
                    fontSize: size / 4.1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: size / 30,
                  ),
                ),
              ],
            ),
          ),
          if (badgeLabel != null)
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAccent,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                  border: Border.all(
                    color: AppColors.surface.withValues(alpha: 0.92),
                  ),
                ),
                child: Text(
                  badgeLabel!,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: AppSpacing.sm + AppSpacing.xs,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarPalette {
  const _AvatarPalette({
    required this.start,
    required this.end,
  });

  final Color start;
  final Color end;
}

const List<_AvatarPalette> _avatarPalettes = <_AvatarPalette>[
  _AvatarPalette(
    start: AppColors.avatarGradientStart,
    end: AppColors.avatarGradientEnd,
  ),
  _AvatarPalette(
    start: AppColors.headerGradientStart,
    end: AppColors.headerGradientMid1,
  ),
  _AvatarPalette(
    start: AppColors.secondary,
    end: AppColors.primary,
  ),
  _AvatarPalette(
    start: AppColors.surfaceAccent,
    end: AppColors.headerGradientMid1,
  ),
];
