import 'dart:ui';

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../home/home_page.dart';
import '../category/category_page.dart';
import '../cart/cart_page.dart';
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
    CategoryPage(),
    CartPage(),
    MyPage(),
  ];

  List<GlobalKey<FramesAnimationState>> framesKeys = [
    GlobalKey<FramesAnimationState>(debugLabel: 'home_key'),
    GlobalKey<FramesAnimationState>(debugLabel: 'category_key'),
    GlobalKey<FramesAnimationState>(debugLabel: 'cart_key'),
    GlobalKey<FramesAnimationState>(debugLabel: 'mine_key'),
  ];

  int _currentIndex = 0;
  int lastIndex = 0;

  List<Image> _loadImages(String type) {
    List<Image> imageList = [];
    for (var i = 0; i < 24; i++) {
      imageList.add(Image.asset(
        'assets/images/${type}_frames/${type}_frame_${i}.png',
        width: 21.0,
        height: 21.0,
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
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.7),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, -6),
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
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.textPrimary.withValues(
                  alpha: 0.72,
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
                      images: _loadImages('category'),
                    ),
                    label: '分类',
                  ),
                  BottomNavigationBarItem(
                    icon: FramesAnimation(
                      key: framesKeys[2],
                      initIndex: 2,
                      images: _loadImages('cart'),
                    ),
                    label: '购物车',
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
