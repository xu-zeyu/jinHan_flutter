import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class HomeStatusPanel extends StatelessWidget {
  const HomeStatusPanel({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  final String? errorMessage;
  final Future<bool> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorMessage!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => onRetry(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accent,
                ),
                child: const Text('重新加载'),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox(
      height: 200,
      child: Center(
        child: Text(
          '暂无商品',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class HomeSkeletonView extends StatelessWidget {
  const HomeSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SkeletonHeroSection(),
        _SkeletonProductGrid(),
      ],
    );
  }
}

class _SkeletonHeroSection extends StatelessWidget {
  const _SkeletonHeroSection();

  @override
  Widget build(BuildContext context) {
    final topSafeHeight = MediaQuery.paddingOf(context).top;
    final navBarHeight = topSafeHeight + 44;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 180 + navBarHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.surfaceAccent.withValues(alpha: 0.72),
                AppColors.surfaceMuted,
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              SizedBox(height: navBarHeight),
              const SkeletonBox(
                width: double.infinity,
                height: 124,
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: Colors.white70,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.72),
                  ),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        SkeletonBox(width: 72, height: 16),
                        Spacer(),
                        SkeletonBox(width: 54, height: 12),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: [
                        for (var i = 0; i < 8; i++)
                          const SizedBox(
                            width: 68,
                            child: Column(
                              children: [
                                SkeletonBox(
                                  width: 58,
                                  height: 58,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                SizedBox(height: 6),
                                SkeletonBox(width: 42, height: 10),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonProductGrid extends StatelessWidget {
  const _SkeletonProductGrid();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.contentBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: GridView.builder(
        itemCount: 6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.58,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 12,
                  offset: Offset(0, 4),
                  color: AppColors.shadow,
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    width: double.infinity,
                    height: 160,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  SizedBox(height: 12),
                  SkeletonBox(width: double.infinity, height: 14),
                  SizedBox(height: 8),
                  SkeletonBox(width: 110, height: 14),
                  SizedBox(height: 10),
                  SkeletonBox(width: 72, height: 16),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SkeletonBox(width: 32, height: 14),
                      SizedBox(width: 8),
                      Expanded(
                        child: SkeletonBox(width: double.infinity, height: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.color = AppColors.placeholder,
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color color;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.55, end: 1).animate(_controller),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: widget.borderRadius,
        ),
      ),
    );
  }
}
