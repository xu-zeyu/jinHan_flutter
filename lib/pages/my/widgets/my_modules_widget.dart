import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'my_module_showcase_card.dart';

/// 我的页面订单模块卡片。
class OrderModuleWidget extends StatelessWidget {
  const OrderModuleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyModuleShowcaseCard(
      title: '订单模块',
      subtitle: '统一查看付款、发货、收货和售后进度。',
      trailing: '7 待处理',
      accentColor: AppColors.orderPending,
      backgroundColor: AppColors.surfaceAccent,
      animationType: MyModuleAnimationType.order,
      metrics: <MyModuleMetricData>[
        MyModuleMetricData(label: '待付款', value: '2'),
        MyModuleMetricData(label: '待收货', value: '4'),
      ],
      actions: <MyModuleActionData>[
        MyModuleActionData(
          title: '全部订单',
          subtitle: '快速进入订单列表',
          icon: Icons.receipt_long_rounded,
        ),
        MyModuleActionData(
          title: '物流进度',
          subtitle: '查看配送与签收状态',
          icon: Icons.local_shipping_outlined,
        ),
        MyModuleActionData(
          title: '退款售后',
          subtitle: '处理异常订单与退款',
          icon: Icons.support_agent_rounded,
        ),
      ],
    );
  }
}

/// 我的页面宠物寄养模块卡片。
class PetBoardingModuleWidget extends StatelessWidget {
  const PetBoardingModuleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyModuleShowcaseCard(
      title: '宠物寄养模块',
      subtitle: '档期预约、入住动态和宠物偏好集中管理。',
      trailing: '本周热度',
      accentColor: AppColors.orderCompleted,
      backgroundColor: AppColors.infoBackground,
      animationType: MyModuleAnimationType.petBoarding,
      metrics: <MyModuleMetricData>[
        MyModuleMetricData(label: '空余房型', value: '3'),
        MyModuleMetricData(label: '照护动态', value: '12'),
      ],
      actions: <MyModuleActionData>[
        MyModuleActionData(
          title: '寄养预约',
          subtitle: '选择日期与房型',
          icon: Icons.calendar_month_rounded,
        ),
        MyModuleActionData(
          title: '入住记录',
          subtitle: '查看历史寄养记录',
          icon: Icons.home_work_rounded,
        ),
        MyModuleActionData(
          title: '宠物档案',
          subtitle: '同步偏好与喂养提醒',
          icon: Icons.pets_rounded,
        ),
      ],
    );
  }
}

/// 我的页面通用模块卡片。
class GeneralModuleWidget extends StatelessWidget {
  const GeneralModuleWidget({
    super.key,
    required this.onThemeTap,
  });

  final VoidCallback onThemeTap;

  @override
  Widget build(BuildContext context) {
    return MyModuleShowcaseCard(
      title: '通用模块',
      subtitle: '主题、客服、优惠券和地址等高频能力入口。',
      trailing: '高频服务',
      accentColor: AppColors.accent,
      backgroundColor: AppColors.cardTint,
      animationType: MyModuleAnimationType.general,
      metrics: const <MyModuleMetricData>[
        MyModuleMetricData(label: '可用优惠券', value: '6'),
        MyModuleMetricData(label: '常用地址', value: '2'),
      ],
      actions: <MyModuleActionData>[
        MyModuleActionData(
          title: '主题外观',
          subtitle: '切换显示风格',
          icon: Icons.palette_outlined,
          onTap: onThemeTap,
        ),
        const MyModuleActionData(
          title: '专属客服',
          subtitle: '在线协助与售后咨询',
          icon: Icons.support_agent_rounded,
        ),
        const MyModuleActionData(
          title: '地址管理',
          subtitle: '维护收货与上门服务地址',
          icon: Icons.location_on_outlined,
        ),
      ],
    );
  }
}
