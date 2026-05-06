import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

enum MessagePageAvatarType { wechat, system, support }

/// 消息页头像组件，根据入口类型切换不同视觉样式。
class MessagePageAvatarWidget extends StatelessWidget {
  const MessagePageAvatarWidget({
    super.key,
    required this.type,
  });

  static const double _avatarSize =
      AppSpacing.xl + AppSpacing.lg;
  static const double _wechatBackIconSize = AppSpacing.lg;
  static const double _wechatFrontIconSize = AppSpacing.lg;
  static const double _systemInset = AppSpacing.xs;

  final MessagePageAvatarType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MessagePageAvatarType.wechat:
        return const _WechatAvatar();
      case MessagePageAvatarType.system:
        return const _SystemAvatar();
      case MessagePageAvatarType.support:
        return const _SupportAvatar();
    }
  }
}

class _WechatAvatar extends StatelessWidget {
  const _WechatAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MessagePageAvatarWidget._avatarSize,
      height: MessagePageAvatarWidget._avatarSize,
      decoration: const BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
      ),
      child: const Stack(
        children: <Widget>[
          Positioned(
            left: AppSpacing.sm,
            top: AppSpacing.md,
            child: Icon(
              CupertinoIcons.chat_bubble_fill,
              color: AppColors.surface,
              size: MessagePageAvatarWidget._wechatBackIconSize,
            ),
          ),
          Positioned(
            right: AppSpacing.sm,
            bottom: AppSpacing.sm,
            child: Icon(
              CupertinoIcons.chat_bubble_fill,
              color: AppColors.surface,
              size: MessagePageAvatarWidget._wechatFrontIconSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemAvatar extends StatelessWidget {
  const _SystemAvatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MessagePageAvatarWidget._avatarSize,
      height: MessagePageAvatarWidget._avatarSize,
      child: Padding(
        padding: const EdgeInsets.all(MessagePageAvatarWidget._systemInset),
        child: SvgPicture.asset('assets/images/service_sys.svg'),
      ),
    );
  }
}

class _SupportAvatar extends StatelessWidget {
  const _SupportAvatar();

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/images/service_kefu.jpg',
        width: MessagePageAvatarWidget._avatarSize,
        height: MessagePageAvatarWidget._avatarSize,
        fit: BoxFit.cover,
      ),
    );
  }
}
