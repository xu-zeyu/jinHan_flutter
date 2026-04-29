import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'my_section_shell.dart';

class BoardingSection extends StatelessWidget {
  const BoardingSection({super.key});

  static const List<_BoardingServiceData> _services = <_BoardingServiceData>[
    _BoardingServiceData(
      title: '寄养预约',
      subtitle: '一键提交档期',
      icon: Icons.calendar_month_rounded,
      color: Color(0xFFD08A53),
    ),
    _BoardingServiceData(
      title: '房型选择',
      subtitle: '标准 / 景观房',
      icon: Icons.home_work_rounded,
      color: Color(0xFF7A9877),
    ),
    _BoardingServiceData(
      title: '实时动态',
      subtitle: '喂养与遛放回传',
      icon: Icons.videocam_rounded,
      color: Color(0xFF6688A7),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MySectionCard(
      child: Column(
        children: <Widget>[
          const MySectionHeader(
            title: '寄养模块',
            subtitle: '补齐预约、房型、动态回传等关键信息',
            trailing: '立即预约',
          ),
          const SizedBox(height: 14),
          const _BoardingHeroCard(),
          const SizedBox(height: 12),
          Row(
            children: _services
                .map(
                  (_BoardingServiceData service) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: service == _services.last ? 0 : 10,
                      ),
                      child: _BoardingServiceTile(service: service),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _BoardingHeroCard extends StatelessWidget {
  const _BoardingHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFF8F0DE),
            Color(0xFFF0DFC0),
            Color(0xFFFFFFFF),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '五一假期档期紧张',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '高峰档建议提前 3-5 天预约，并同步宠物喂养偏好。',
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
          _BoardingLoadTag(),
        ],
      ),
    );
  }
}

class _BoardingLoadTag extends StatelessWidget {
  const _BoardingLoadTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '82%',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 2),
          Text(
            '入住率',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardingServiceTile extends StatelessWidget {
  const _BoardingServiceTile({required this.service});

  final _BoardingServiceData service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: service.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: service.color.withValues(alpha: 0.18)),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: service.color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(service.icon, color: service.color, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                service.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                service.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoardingServiceData {
  const _BoardingServiceData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}
