import 'dart:ui';

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../home/home_page.dart';
import '../business/business_page.dart';
import '../message/message_page.dart';
import '../my/my_page.dart';
import 'frames_animation.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> pageList = const [
    HomePage(),
    BusinessPage(),
    MessagePage(),
    MyPage(),
  ];

  List<GlobalKey<FramesAnimationState>> framesKeys = [
    GlobalKey<FramesAnimationState>(debugLabel: 'home_key'),
    GlobalKey<FramesAnimationState>(debugLabel: 'business_key'),
    GlobalKey<FramesAnimationState>(debugLabel: 'message_key'),
    GlobalKey<FramesAnimationState>(debugLabel: 'mine_key'),
  ];

  int _currentIndex = 0;
  int lastIndex = 0;

  List<Image> _loadImages(String type) {
    List<Image> imageList = [];
    for (var i = 0; i < 24; i++) {
      imageList.add(Image.asset(
        'assets/images/${type}_frames/${type}_frame_$i.png',
        width: 27.0,
        height: 27.0,
        fit: BoxFit.fill,
        gaplessPlayback: true,
      ));
    }
    return imageList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: pageList,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.94),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.84),
                width: 0.8,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 28,
                  offset: Offset(0, -10),
                ),
              ],
            ),
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                selectedFontSize: 11.0,
                unselectedFontSize: 11.0,
                selectedItemColor: AppColors.accent,
                unselectedItemColor: AppColors.textSecondary,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                currentIndex: _currentIndex,
                type: BottomNavigationBarType.fixed,
                onTap: (int index) {
                  if (lastIndex == index) return;
                  framesKeys[index].currentState?.startAnimation();
                  framesKeys[lastIndex].currentState?.resetAnimation();
                  lastIndex = index;
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: FramesAnimation(
                      key: framesKeys[0],
                      initIndex: 0,
                      images: _loadImages('home'),
                    ),
                    label: '首页',
                  ),
                  BottomNavigationBarItem(
                    icon: FramesAnimation(
                      key: framesKeys[1],
                      initIndex: 1,
                      images: _loadImages('business'),
                    ),
                    label: '商家',
                  ),
                  BottomNavigationBarItem(
                    icon: FramesAnimation(
                      key: framesKeys[2],
                      initIndex: 2,
                      images: _loadImages('message'),
                    ),
                    label: '信息',
                  ),
                  BottomNavigationBarItem(
                    icon: FramesAnimation(
                      key: framesKeys[3],
                      initIndex: 3,
                      images: _loadImages('mine'),
                    ),
                    label: '我的',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
