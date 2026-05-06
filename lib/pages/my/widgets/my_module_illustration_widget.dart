import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import 'my_module_showcase_card.dart';

/// 模块插画区域，负责持续驱动卡片中的 SVG 浮动动画。
class MyModuleIllustrationWidget extends StatefulWidget {
  const MyModuleIllustrationWidget({
    super.key,
    required this.type,
    required this.accentColor,
    required this.backgroundColor,
  });

  final MyModuleAnimationType type;
  final Color accentColor;
  final Color backgroundColor;

  @override
  State<MyModuleIllustrationWidget> createState() =>
      _MyModuleIllustrationWidgetState();
}

class _MyModuleIllustrationWidgetState extends State<MyModuleIllustrationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<_SvgLayerData> layers = _buildLayers(widget.type);
    return Container(
      height: AppSpacing.xl * 4,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.border),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: <Widget>[
              _buildGlow(
                alignment: Alignment.topRight,
                scale: 1 + math.sin(_controller.value * math.pi * 2) * 0.08,
                color: widget.accentColor.withValues(alpha: 0.14),
              ),
              _buildGlow(
                alignment: Alignment.bottomLeft,
                scale: 1 + math.cos(_controller.value * math.pi * 2) * 0.06,
                color: AppColors.surface.withValues(alpha: 0.45),
              ),
              for (final _SvgLayerData layer in layers)
                _AnimatedSvgLayer(
                  layer: layer,
                  progress: _controller.value,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGlow({
    required Alignment alignment,
    required double scale,
    required Color color,
  }) {
    return Align(
      alignment: alignment,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: AppSpacing.xl * 2 + AppSpacing.lg,
          height: AppSpacing.xl * 2 + AppSpacing.lg,
          margin: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  List<_SvgLayerData> _buildLayers(MyModuleAnimationType type) {
    switch (type) {
      case MyModuleAnimationType.order:
        return const <_SvgLayerData>[
          _SvgLayerData(
            assetPath: 'assets/images/ic_order_pending_payment.svg',
            alignment: Alignment.centerLeft,
            width: AppSpacing.xl + AppSpacing.xl + AppSpacing.md,
            amplitude: 8,
            scaleAmplitude: 0.04,
          ),
          _SvgLayerData(
            assetPath: 'assets/images/ic_order_pending_shipment.svg',
            alignment: Alignment.topRight,
            width: AppSpacing.xl + AppSpacing.lg,
            amplitude: 6,
            phase: 0.8,
            scaleAmplitude: 0.06,
          ),
          _SvgLayerData(
            assetPath: 'assets/images/ic_order_completed.svg',
            alignment: Alignment.bottomRight,
            width: AppSpacing.xl + AppSpacing.md,
            amplitude: 7,
            phase: 1.6,
            rotationAmplitude: 0.05,
          ),
        ];
      case MyModuleAnimationType.petBoarding:
        return const <_SvgLayerData>[
          _SvgLayerData(
            assetPath: 'assets/images/ic_pet_boarding.svg',
            alignment: Alignment.center,
            width: AppSpacing.xl * 2 + AppSpacing.lg,
            amplitude: 8,
            scaleAmplitude: 0.05,
          ),
          _SvgLayerData(
            assetPath: 'assets/images/ic_pet_boarding.svg',
            alignment: Alignment.topLeft,
            width: AppSpacing.xl + AppSpacing.md,
            amplitude: 6,
            phase: 1.1,
            rotationAmplitude: 0.08,
          ),
          _SvgLayerData(
            assetPath: 'assets/images/ic_pet_boarding.svg',
            alignment: Alignment.bottomRight,
            width: AppSpacing.xl + AppSpacing.md,
            amplitude: 5,
            phase: 2.2,
            rotationAmplitude: -0.06,
          ),
        ];
      case MyModuleAnimationType.general:
        return const <_SvgLayerData>[
          _SvgLayerData(
            assetPath: 'assets/images/ic_coupon.svg',
            alignment: Alignment.centerLeft,
            width: AppSpacing.xl + AppSpacing.xl + AppSpacing.md,
            amplitude: 7,
            scaleAmplitude: 0.05,
          ),
          _SvgLayerData(
            assetPath: 'assets/images/ic_customer_service.svg',
            alignment: Alignment.topRight,
            width: AppSpacing.xl + AppSpacing.lg,
            amplitude: 5,
            phase: 1.2,
            rotationAmplitude: 0.06,
          ),
          _SvgLayerData(
            assetPath: 'assets/images/ic_address.svg',
            alignment: Alignment.bottomRight,
            width: AppSpacing.xl + AppSpacing.md,
            amplitude: 6,
            phase: 2,
            scaleAmplitude: 0.04,
          ),
        ];
    }
  }
}

class _AnimatedSvgLayer extends StatelessWidget {
  const _AnimatedSvgLayer({
    required this.layer,
    required this.progress,
  });

  final _SvgLayerData layer;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final double angle = progress * math.pi * 2 + layer.phase;
    return Align(
      alignment: layer.alignment,
      child: Transform.translate(
        offset: Offset(math.cos(angle) * 4, math.sin(angle) * layer.amplitude),
        child: Transform.rotate(
          angle: math.sin(angle) * layer.rotationAmplitude,
          child: Transform.scale(
            scale: 1 + math.cos(angle) * layer.scaleAmplitude,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SvgPicture.asset(
                layer.assetPath,
                width: layer.width,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SvgLayerData {
  const _SvgLayerData({
    required this.assetPath,
    required this.alignment,
    required this.width,
    required this.amplitude,
    this.phase = 0,
    this.rotationAmplitude = 0,
    this.scaleAmplitude = 0,
  });

  final String assetPath;
  final Alignment alignment;
  final double width;
  final double amplitude;
  final double phase;
  final double rotationAmplitude;
  final double scaleAmplitude;
}
