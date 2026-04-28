import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/constants/app_colors.dart';

class HomeRefreshHeader extends StatelessWidget {
  const HomeRefreshHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      height: 80,
      refreshStyle: RefreshStyle.Behind,
      completeDuration: const Duration(milliseconds: 120),
      builder: (context, mode) {
        final isAnimating = mode == RefreshStatus.refreshing;
        final assetName = isAnimating
            ? 'assets/images/refreshGif.gif'
            : 'assets/images/refresh.png';

        String text;
        switch (mode) {
          case RefreshStatus.canRefresh:
            text = '松手立即刷新';
            break;
          case RefreshStatus.refreshing:
            text = '正在刷新';
            break;
          case RefreshStatus.completed:
            text = '刷新完成';
            break;
          case RefreshStatus.failed:
            text = '刷新失败';
            break;
          default:
            text = '下拉刷新';
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final hasEnoughSpace = availableHeight > 54;

            return Center(
              child: hasEnoughSpace
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          assetName,
                          width: 28,
                          height: 28,
                          gaplessPlayback: true,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    )
                  : availableHeight > 30
                      ? Image.asset(
                          assetName,
                          width: 24,
                          height: 24,
                          gaplessPlayback: true,
                        )
                      : const SizedBox(),
            );
          },
        );
      },
    );
  }
}

class HomeLoadMoreFooter extends StatelessWidget {
  const HomeLoadMoreFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomSafeHeight = MediaQuery.paddingOf(context).bottom;
    final footerBottomInset =
        bottomSafeHeight + kBottomNavigationBarHeight + 12;

    return CustomFooter(
      builder: (context, mode) {
        Widget child;
        switch (mode) {
          case LoadStatus.loading:
            child = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/loadMoreLoading.gif',
                  width: 28,
                  height: 28,
                  gaplessPlayback: true,
                ),
                const SizedBox(width: 8),
                const Text('正在加载'),
              ],
            );
            break;
          case LoadStatus.failed:
            child = const Text('加载失败，点击重试');
            break;
          case LoadStatus.canLoading:
            child = const Text('松手加载更多');
            break;
          case LoadStatus.noMore:
            child = const Text('已经到底了');
            break;
          default:
            child = const Text('上拉加载更多');
        }

        return SizedBox(
          height: 56 + footerBottomInset,
          child: Padding(
            padding: EdgeInsets.only(bottom: footerBottomInset),
            child: Center(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
