import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// 退出登录确认弹窗，负责展示 SVG 动画与二次确认交互。
class LogoutConfirmDialogWidget extends StatefulWidget {
  const LogoutConfirmDialogWidget({
    super.key,
    required this.isSubmitting,
    required this.onConfirm,
  });

  final bool isSubmitting;
  final Future<void> Function() onConfirm;

  @override
  State<LogoutConfirmDialogWidget> createState() =>
      _LogoutConfirmDialogWidgetState();
}

class _LogoutConfirmDialogWidgetState extends State<LogoutConfirmDialogWidget>
    with SingleTickerProviderStateMixin {
  static const double _dialogRadius = AppSpacing.lg;
  static const double _illustrationHeight = AppSpacing.xl * 3 + AppSpacing.lg;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(_dialogRadius),
          border: Border.all(color: AppColors.border),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: AppSpacing.lg,
              offset: Offset(0, AppSpacing.sm),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _AnimatedLogoutIllustration(controller: _controller),
            const SizedBox(height: AppSpacing.md),
            const Text(
              '确认退出当前账号？',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              '退出后将清除本地登录状态，需要重新登录才能继续查看账户与宠物资料。',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: <Widget>[
                Expanded(
                  child: _DialogActionButton(
                    label: '取消',
                    isPrimary: false,
                    isDisabled: widget.isSubmitting,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _DialogActionButton(
                    label: '退出登录',
                    isPrimary: true,
                    isDisabled: widget.isSubmitting,
                    isLoading: widget.isSubmitting,
                    onTap: widget.onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedLogoutIllustration extends StatelessWidget {
  const _AnimatedLogoutIllustration({
    required this.controller,
  });

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _LogoutConfirmDialogWidgetState._illustrationHeight,
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          final double progress = controller.value;
          final double angle = progress * math.pi * 2;
          final double floatOffset = math.sin(angle) * AppSpacing.sm;
          final double pulseScale = 1 + math.cos(angle) * 0.04;
          final double haloScale = 1 + math.sin(angle) * 0.08;

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.scale(
                scale: haloScale,
                child: Container(
                  width: AppSpacing.xl * 3 + AppSpacing.md,
                  height: AppSpacing.xl * 3 + AppSpacing.md,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceAccent.withValues(alpha: 0.82),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, floatOffset),
                child: Transform.scale(
                  scale: pulseScale,
                  child: SvgPicture.asset(
                    'assets/images/ic_logout_dialog.svg',
                    width: AppSpacing.xl * 3 + AppSpacing.md,
                    height: AppSpacing.xl * 3 + AppSpacing.md,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({
    required this.label,
    required this.isPrimary,
    required this.isDisabled,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final bool isPrimary;
  final bool isDisabled;
  final bool isLoading;
  final FutureOr<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isPrimary ? AppColors.accent : AppColors.surfaceMuted;
    final Color borderColor = isPrimary ? AppColors.accent : AppColors.border;
    final Color textColor =
        isPrimary ? AppColors.surface : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.md - AppSpacing.xs),
        onTap: isDisabled
            ? null
            : () {
                onTap();
              },
        child: Ink(
          height: AppSpacing.xl + AppSpacing.md,
          decoration: BoxDecoration(
            color: isDisabled
                ? backgroundColor.withValues(alpha: 0.56)
                : backgroundColor,
            borderRadius: BorderRadius.circular(AppSpacing.md - AppSpacing.xs),
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: AppSpacing.md + AppSpacing.xs,
                    height: AppSpacing.md + AppSpacing.xs,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
