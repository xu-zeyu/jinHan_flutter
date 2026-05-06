import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import 'message_conversation_tile_widget.dart';
import 'message_page_avatar_widget.dart';

/// 消息页主体，按参考视觉展示顶部标题与三条核心消息入口。
class MessagePageBodyWidget extends StatelessWidget {
  const MessagePageBodyWidget({super.key});

  static const List<_MessageConversationItem> _items =
      <_MessageConversationItem>[
    _MessageConversationItem(
      title: '微信通知',
      subtitle: '开启微信通知，及时查看消息和订单状态',
      avatarType: MessagePageAvatarType.wechat,
    ),
    _MessageConversationItem(
      title: '系统通知',
      subtitle: '消息推送、平台通知、状态通知',
      timeLabel: '刚刚',
      avatarType: MessagePageAvatarType.system,
    ),
    _MessageConversationItem(
      title: '官方客服',
      subtitle: '工作日 9:00-18:00 在线',
      timeLabel: '刚刚',
      badgeLabel: '官方',
      avatarType: MessagePageAvatarType.support,
    ),
  ];

  static const double _horizontalPadding = AppSpacing.lg;
  static const double _contentTopSpacing = AppSpacing.md;
  static const double _itemSpacing = AppSpacing.xl ;
  static const double _bottomInset =
      AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _horizontalPadding,
        _contentTopSpacing,
        _horizontalPadding,
        _bottomInset,
      ),
      child: Column(
        children: _buildConversationTiles(),
      ),
    );
  }

  List<Widget> _buildConversationTiles() {
    return List<Widget>.generate(_items.length, (int index) {
      final _MessageConversationItem item = _items[index];
      return Padding(
        padding: EdgeInsets.only(
          bottom: index == _items.length - 1 ? 0 : _itemSpacing,
        ),
        child: MessageConversationTileWidget(
          title: item.title,
          subtitle: item.subtitle,
          timeLabel: item.timeLabel,
          badgeLabel: item.badgeLabel,
          avatar: MessagePageAvatarWidget(type: item.avatarType),
        ),
      );
    });
  }
}

class _MessageConversationItem {
  const _MessageConversationItem({
    required this.title,
    required this.subtitle,
    required this.avatarType,
    this.timeLabel,
    this.badgeLabel,
  });

  final String title;
  final String subtitle;
  final String? timeLabel;
  final String? badgeLabel;
  final MessagePageAvatarType avatarType;
}
