import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';

/// 商家页面顶部导航栏，仅展示页面标题。
class BusinessNavBarWidget extends StatelessWidget {
  const BusinessNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '商家',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: AppSpacing.md,
            fontWeight: FontWeight.w800,
          ),
    );
  }
}
