import 'package:flutter/material.dart';

/// 消息页面顶部导航栏，仅展示页面标题。
class MessageNavBarWidget extends StatelessWidget {
  const MessageNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '消息',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }
}
