import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// 登录页沉浸式背景，使用品牌渐变与应用图标水印建立主题氛围。
class LoginBackgroundWidget extends StatelessWidget {
  const LoginBackgroundWidget({super.key});

  static const double _watermarkSize = AppSpacing.xl * 5;
  static const double _watermarkOpacity = 0.08;
  static const double _bottomBandOpacity = 0.92;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.headerGradientEnd,
            AppColors.headerGradientMid2,
            AppColors.headerGradientMid1,
            AppColors.surfaceAccent,
            AppColors.background,
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Opacity(
                opacity: _watermarkOpacity,
                child: Image.asset(
                  'assets/images/app_icon.png',
                  width: _watermarkSize,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    AppColors.surfaceAccent.withValues(alpha: 0),
                    AppColors.background.withValues(alpha: _bottomBandOpacity),
                    AppColors.contentBackground,
                  ],
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}
