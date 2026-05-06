import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import 'my_modules_widget.dart';
import 'my_section_entry.dart';

/// 我的页面主体，集中展示订单、宠物寄养和通用功能模块。
class MyPageBody extends StatelessWidget {
  const MyPageBody({
    super.key,
    required this.entranceController,
    required this.onThemeTap,
  });

  final AnimationController entranceController;
  final VoidCallback onThemeTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm + AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xl + AppSpacing.xl + AppSpacing.xl + AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MySectionEntry(
            controller: entranceController,
            index: 0,
            child: const OrderModuleWidget(),
          ),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          MySectionEntry(
            controller: entranceController,
            index: 1,
            child: const PetBoardingModuleWidget(),
          ),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          MySectionEntry(
            controller: entranceController,
            index: 2,
            child: GeneralModuleWidget(onThemeTap: onThemeTap),
          ),
        ],
      ),
    );
  }
}
