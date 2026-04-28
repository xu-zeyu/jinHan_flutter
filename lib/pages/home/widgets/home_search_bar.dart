import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.topSafeHeight,
    required this.bgOpacity,
    required this.translateX,
  });

  final double topSafeHeight;
  final double bgOpacity;
  final double translateX;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: topSafeHeight + 44,
      color: AppColors.primary.withOpacity(bgOpacity),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: bgOpacity,
              child: Padding(
                padding: EdgeInsets.only(top: topSafeHeight, left: 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    'assets/images/home_appBar_bg.svg',
                    width: 120,
                    height: 36,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14, topSafeHeight, 14, 0),
            child: SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                    offset: Offset(translateX, 0),
                    child: Container(
                      width: 120,
                      height: 28,
                      padding: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/search.svg',
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '搜宠物',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'assets/images/share.svg',
                          width: 22,
                          height: 22,
                        ),
                        SvgPicture.asset(
                          'assets/images/scan.svg',
                          width: 22,
                          height: 22,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
