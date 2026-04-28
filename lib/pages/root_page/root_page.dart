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
  PageController? _controller;
  List<Widget> pageList = const [HomePage(), CategoryPage(), CartPage(), MyPage()];

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
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: pageList,
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
      ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(
                color: AppColors.border,
                width: 0.5,
              ),
            ),
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
              unselectedItemColor: AppColors.textPrimary,
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (int index) {
                if (lastIndex == index) return;
                _controller!.jumpToPage(index);
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
    );
  }
}
