import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'my_section_shell.dart';

class PetSection extends StatelessWidget {
  const PetSection({super.key});

  static const List<_PetData> _pets = <_PetData>[
    _PetData(
      name: '奶糖',
      type: '布偶猫',
      age: '2岁3个月',
      imagePath: 'assets/images/app_icon.png',
      status: '疫苗已完成',
      reminder: '5月8日 复查',
      accent: Color(0xFFDA9B68),
    ),
    _PetData(
      name: '元宝',
      type: '柯基犬',
      age: '1岁8个月',
      imagePath: 'assets/images/app_icon.png',
      status: '体重管理中',
      reminder: '本周需遛狗 3 次',
      accent: Color(0xFF769B87),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MySectionCard(
      child: Column(
        children: <Widget>[
          const MySectionHeader(
            title: '爱宠模块',
            subtitle: '集中管理档案、健康提醒和日常照护',
            trailing: '新增爱宠',
          ),
          const SizedBox(height: 14),
          const _PetHeroPanel(),
          const SizedBox(height: 12),
          ..._pets.map(
            (_PetData pet) => Padding(
              padding: EdgeInsets.only(bottom: pet == _pets.last ? 0 : 10),
              child: _PetTile(pet: pet),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetHeroPanel extends StatelessWidget {
  const _PetHeroPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '已绑定 2 只爱宠',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '健康档案、生日、喂养和护理计划统一管理。',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.pets_rounded,
            color: AppColors.accent,
            size: 28,
          ),
        ],
      ),
    );
  }
}

class _PetTile extends StatelessWidget {
  const _PetTile({required this.pet});

  final _PetData pet;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: pet.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: pet.accent.withValues(alpha: 0.18)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: pet.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(pet.imagePath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            pet.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        _PetStatusTag(
                          label: pet.status,
                          accent: pet.accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.type}  ·  ${pet.age}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.notifications_active_rounded,
                          size: 14,
                          color: pet.accent,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            pet.reminder,
                            style: TextStyle(
                              color: pet.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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
        style: TextStyle(
          color: accent,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PetData {
  const _PetData({
    required this.name,
    required this.type,
    required this.age,
    required this.imagePath,
    required this.status,
    required this.reminder,
    required this.accent,
  });

  final String name;
  final String type;
  final String age;
  final String imagePath;
  final String status;
  final String reminder;
  final Color accent;
}
