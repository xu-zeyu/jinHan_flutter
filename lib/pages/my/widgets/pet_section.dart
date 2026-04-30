import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../shared/models/user_models.dart';
import 'my_section_shell.dart';
import 'responsive_wrap.dart';

/// 登录后展示的宠物档案列表。
class PetSection extends StatelessWidget {
  const PetSection({
    super.key,
    required this.pets,
  });

  final List<UserPetModel> pets;

  @override
  Widget build(BuildContext context) {
    return MySectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MySectionHeader(
            title: '宠物档案',
            subtitle: pets.isEmpty
                ? '当前账号还没有同步任何爱宠资料。'
                : '展示 `/user` 聚合接口返回的完整 `petList` 数据。',
            trailing: pets.isEmpty ? '空档案' : '${pets.length} 只',
          ),
          const SizedBox(height: AppSpacing.md - 2),
          _PetSummaryPanel(pets: pets),
          const SizedBox(height: AppSpacing.md - 4),
          if (pets.isEmpty)
            const _PetEmptyState()
          else
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double itemWidth = calculateMySectionItemWidth(
                  constraints,
                );

                return Wrap(
                  spacing: kMySectionItemSpacing,
                  runSpacing: kMySectionItemSpacing,
                  children: pets.map((UserPetModel pet) {
                    return SizedBox(
                      width: itemWidth,
                      child: _PetTile(pet: pet),
                    );
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _PetSummaryPanel extends StatelessWidget {
  const _PetSummaryPanel({required this.pets});

  final List<UserPetModel> pets;

  @override
  Widget build(BuildContext context) {
    final int catCount =
        pets.where((UserPetModel item) => item.petTypeCode == 'CAT').length;
    final int dogCount =
        pets.where((UserPetModel item) => item.petTypeCode == 'DOG').length;
    final DateTime? latestUpdate = pets
        .map((UserPetModel item) => item.updatedTime ?? item.createdTime)
        .whereType<DateTime>()
        .fold<DateTime?>(null, (DateTime? previous, DateTime next) {
      if (previous == null || next.isAfter(previous)) {
        return next;
      }
      return previous;
    });

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md - 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  pets.isEmpty ? '还没有宠物资料' : '已同步 ${pets.length} 只爱宠',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(
                Icons.pets_rounded,
                color: AppColors.accent,
                size: AppSpacing.lg,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          Text(
            pets.isEmpty
                ? '登录后的资料页已经接入真实接口，等新增宠物后这里会直接展示。'
                : '最近更新 ${AppDateUtils.formatDateTime(latestUpdate, pattern: 'yyyy-MM-dd HH:mm', fallback: '暂无记录')}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.md - 4),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              _PetInfoChip(
                icon: Icons.tag_outlined,
                label: '猫咪 $catCount 只',
              ),
              _PetInfoChip(
                icon: Icons.pets_outlined,
                label: '狗狗 $dogCount 只',
              ),
              if (pets.isNotEmpty)
                _PetInfoChip(
                  icon: Icons.note_alt_outlined,
                  label:
                      '有备注 ${pets.where((UserPetModel item) => item.remark.isNotEmpty).length} 只',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PetTile extends StatelessWidget {
  const _PetTile({required this.pet});

  final UserPetModel pet;

  @override
  Widget build(BuildContext context) {
    final Color accent = _petAccentColor(pet.petTypeCode);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md - 4),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.md),
            border: Border.all(color: accent.withValues(alpha: 0.18)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: _PetAvatar(
                  imageUrl: pet.avatarUrl,
                  iconColor: accent,
                ),
              ),
              const SizedBox(width: AppSpacing.md - 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pet.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${pet.displayType}  ·  ${pet.displayGender}  ·  ${pet.ageText}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs + 2,
                      runSpacing: AppSpacing.xs + 2,
                      children: <Widget>[
                        _PetStatusTag(
                          label: pet.birthdayText,
                          accent: accent,
                        ),
                        _PetReminderTag(
                          label: pet.remarkText,
                          accent: accent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetAvatar extends StatelessWidget {
  const _PetAvatar({
    required this.imageUrl,
    required this.iconColor,
  });

  final String imageUrl;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Icon(Icons.pets_rounded, color: iconColor, size: 24);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
          return Icon(Icons.pets_rounded, color: iconColor, size: 24);
        },
      ),
    );
  }
}

class _PetInfoChip extends StatelessWidget {
  const _PetInfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PetEmptyState extends StatelessWidget {
  const _PetEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: const Column(
        children: <Widget>[
          Icon(
            Icons.pets_outlined,
            color: AppColors.textSecondary,
            size: AppSpacing.xl,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            '暂无宠物档案',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            '后续新增爱宠后，这里会按后端返回的真实数据自动展示。',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PetStatusTag extends StatelessWidget {
  const _PetStatusTag({
    required this.label,
    required this.accent,
  });

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: accent,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PetReminderTag extends StatelessWidget {
  const _PetReminderTag({
    required this.label,
    required this.accent,
  });

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.notifications_active_rounded,
            size: 12,
            color: accent,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: accent,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _petAccentColor(String petTypeCode) {
  switch (petTypeCode) {
    case 'DOG':
      return AppColors.orderCompleted;
    case 'BIRD':
      return AppColors.orderReceiving;
    case 'RABBIT':
      return AppColors.quickActionAddress;
    case 'OTHER':
      return AppColors.info;
    case 'CAT':
    default:
      return AppColors.quickActionCoupon;
  }
}
