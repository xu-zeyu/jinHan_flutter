import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// 单条消息入口，承载头像、标题、副标题与时间信息。
class MessageConversationTileWidget extends StatelessWidget {
  const MessageConversationTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.avatar,
    this.timeLabel,
    this.badgeLabel,
  });

  static const double _avatarTextSpacing = AppSpacing.sm;
  static const double _titleBadgeSpacing = AppSpacing.sm;
  static const double _titleSubtitleSpacing = AppSpacing.sm;
  static const double _timeSlotWidth = AppSpacing.xl;

  final String title;
  final String subtitle;
  final Widget avatar;
  final String? timeLabel;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        avatar,
        const SizedBox(width: _avatarTextSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge?.copyWith(
                              fontSize: AppSpacing.md,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (badgeLabel != null) ...<Widget>[
                          const SizedBox(width: _titleBadgeSpacing),
                          _ConversationBadge(label: badgeLabel!),
                        ],
                      ],
                    ),
                  ),
                  if (timeLabel != null) ...<Widget>[
                    const SizedBox(width: AppSpacing.sm),
                    SizedBox(
                      width: _timeSlotWidth,
                      child: Text(
                        timeLabel!,
                        textAlign: TextAlign.right,
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: AppSpacing.lg - AppSpacing.sm - AppSpacing.xs,
                          color:
                              AppColors.textSecondary.withValues(alpha: 0.28),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: _titleSubtitleSpacing),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: AppSpacing.lg - AppSpacing.sm - AppSpacing.xs,
                  color: AppColors.textSecondary.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConversationBadge extends StatelessWidget {
  const _ConversationBadge({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: AppSpacing.md - AppSpacing.xs,
            color: AppColors.favoriteTextDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
