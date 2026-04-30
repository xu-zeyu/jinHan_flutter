import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// 登录页背景，提供渐变与轻量装饰层次。
class LoginBackgroundWidget extends StatelessWidget {
  const LoginBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.surface,
            AppColors.surfaceAccent.withValues(alpha: 0.9),
            AppColors.background,
            AppColors.secondary.withValues(alpha: 0.28),
          ],
        ),
      ),
      child: const Stack(
        children: <Widget>[
          _GradientOrb(
            alignment: Alignment.topLeft,
            size: AppSpacing.xl * 6,
            color: AppColors.headerGradientStart,
            opacity: 0.16,
          ),
          _GradientOrb(
            alignment: Alignment.topRight,
            size: AppSpacing.xl * 5,
            color: AppColors.secondary,
            opacity: 0.18,
          ),
          _GradientOrb(
            alignment: Alignment.bottomCenter,
            size: AppSpacing.xl * 7,
            color: AppColors.headerGradientMid1,
            opacity: 0.12,
          ),
        ],
      ),
    );
  }
}

class _GradientOrb extends StatelessWidget {
  const _GradientOrb({
    required this.alignment,
    required this.size,
    required this.color,
    required this.opacity,
  });

  final Alignment alignment;
  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              color.withValues(alpha: opacity),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
