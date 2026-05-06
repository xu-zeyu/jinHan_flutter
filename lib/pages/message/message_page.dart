import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import 'widgets/message_page_body_widget.dart';
import 'widgets/message_nav_bar_widget.dart';

/// 消息页面，展示通知与客服等核心消息入口。
class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  static const double _navBarHeight = AppSpacing.xl + AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.surface,
      ),
      child: const Scaffold(
        backgroundColor: AppColors.surface,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: AppColors.surface,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: _navBarHeight,
              title: MessageNavBarWidget(),
            ),
            SliverToBoxAdapter(
              child: MessagePageBodyWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
