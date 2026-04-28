import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/constants/app_colors.dart';
import 'home_models.dart';
import 'home_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();
  final HomeRepository _homeRepository = HomeRepository();

  List<HomeBannerItem> _bannerList = const <HomeBannerItem>[];
  List<HomeVarietyItem> _varietyList = const <HomeVarietyItem>[];
  List<HomeProductItem> _productList = const <HomeProductItem>[];

  double _scrollY = 0;
  double _bgOpacity = 0;
  double _translateX = 0;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  bool _isInitialLoading = true;
  bool _refreshNavLocked = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final offset = _scrollController.offset;
    final nextScrollY = offset <= 0 ? 0.0 : offset;

    if (_refreshNavLocked && nextScrollY == 0) {
      if (_scrollY != 0 || _bgOpacity != 0 || _translateX != 0) {
        setState(_resetNavState);
      }
      return;
    }

    if ((_scrollY - nextScrollY).abs() < 0.5) {
      return;
    }

    setState(() {
      _scrollY = nextScrollY;
      _syncNavState();
    });
  }

  void _syncNavState() {
    if (_scrollY <= 0) {
      _translateX = 0;
      _bgOpacity = 0;
      return;
    }

    _translateX = _scrollY < 140 ? _scrollY : 140;

    final alpha = _scrollY / 100;
    if (alpha <= 0) {
      _bgOpacity = 0;
    } else if (alpha >= 1) {
      _bgOpacity = 1;
    } else {
      _bgOpacity = alpha;
    }
  }

  void _resetNavState() {
    _scrollY = 0;
    _bgOpacity = 0;
    _translateX = 0;
  }

  Future<bool> _loadInitialData({bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _isInitialLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final bannerFuture = _homeRepository.fetchBannerList();
      final varietyFuture = _homeRepository.fetchHotVarietyList();
      final productFuture = _homeRepository.fetchProductPage(page: 1);

      final bannerList = await bannerFuture;
      final varietyList = await varietyFuture;
      final productPage = await productFuture;

      if (!mounted) {
        return true;
      }

      setState(() {
        _bannerList = bannerList;
        _varietyList = varietyList;
        _productList = productPage.records;
        _page = productPage.current;
        _hasMore = _productList.length < productPage.total;
        _isLoadingMore = false;
        _errorMessage = null;
      });
      return true;
    } catch (_) {
      if (!mounted) {
        return false;
      }

      setState(() {
        _bannerList = const <HomeBannerItem>[];
        _varietyList = const <HomeVarietyItem>[];
        _productList = const <HomeProductItem>[];
        _page = 1;
        _hasMore = true;
        _isLoadingMore = false;
        _errorMessage = '首页数据加载失败，请稍后重试';
      });
      return false;
    } finally {
      if (mounted && showLoading) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    _refreshNavLocked = true;

    final success = await _loadInitialData(showLoading: false);
    if (!mounted) {
      return;
    }

    setState(_resetNavState);
    if (success) {
      _refreshController.refreshCompleted();
      _refreshController.resetNoData();
    } else {
      _refreshController.refreshFailed();
    }

    try {
      await Future<void>.delayed(const Duration(milliseconds: 260));
    } finally {
      _refreshNavLocked = false;
      if (mounted &&
          _scrollController.hasClients &&
          _scrollController.position.pixels <= 0) {
        setState(_resetNavState);
      }
    }
  }

  Future<void> _onLoading() async {
    if (_isLoadingMore) {
      _refreshController.loadComplete();
      return;
    }

    if (!_hasMore) {
      _refreshController.loadNoData();
      return;
    }

    _isLoadingMore = true;

    try {
      final nextPage = _page + 1;
      final productPage =
          await _homeRepository.fetchProductPage(page: nextPage);
      if (!mounted) {
        return;
      }

      setState(() {
        _page = productPage.current;
        _productList = <HomeProductItem>[
          ..._productList,
          ...productPage.records,
        ];
        _hasMore = productPage.records.isNotEmpty &&
            _productList.length < productPage.total;
        _isLoadingMore = false;
      });

      if (_hasMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    } catch (_) {
      _isLoadingMore = false;
      _refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topSafeHeight = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _SearchBar(
              topSafeHeight: topSafeHeight,
              bgOpacity: _bgOpacity,
              translateX: _translateX,
            ),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                header: const _RefreshHeader(),
                footer: const _LoadMoreFooter(),
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _HomeHeroSection(
                        banners: _bannerList,
                        varieties: _varietyList,
                      ),
                    ),
                    if (_productList.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                        sliver: SliverMasonryGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childCount: _productList.length,
                          itemBuilder: (context, index) {
                            return _ProductCard(product: _productList[index]);
                          },
                        ),
                      )
                    else
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                          child: _HomeStatusPanel(
                            loading: _isInitialLoading,
                            errorMessage: _errorMessage,
                            onRetry: () => _loadInitialData(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
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
      color: const Color(0xFFF8D147),
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

class _RefreshHeader extends StatelessWidget {
  const _RefreshHeader();

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      height: 64,
      completeDuration: const Duration(milliseconds: 220),
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

        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                assetName,
                width: 28,
                height: 28,
                gaplessPlayback: true,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoadMoreFooter extends StatelessWidget {
  const _LoadMoreFooter();

  @override
  Widget build(BuildContext context) {
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
          height: 56,
          child: Center(
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _HomeHeroSection extends StatelessWidget {
  const _HomeHeroSection({
    required this.banners,
    required this.varieties,
  });

  final List<HomeBannerItem> banners;
  final List<HomeVarietyItem> varieties;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: const BoxDecoration(
            color: Color(0xFFF8D147),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              const SizedBox(height: 14),
              _BannerSwiper(banners: banners),
              const SizedBox(height: 24),
              _HotVarietyGrid(varieties: varieties),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }
}

class _BannerSwiper extends StatelessWidget {
  const _BannerSwiper({required this.banners});

  final List<HomeBannerItem> banners;

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return Container(
        width: double.infinity,
        height: 124,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(14),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 124,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Swiper(
          itemCount: banners.length,
          autoplay: true,
          loop: true,
          duration: 300,
          autoplayDelay: 3000,
          pagination: SwiperPagination(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 10),
            builder: DotSwiperPaginationBuilder(
              size: 6,
              activeSize: 8,
              space: 4,
              color: Colors.white.withOpacity(0.5),
              activeColor: Colors.white,
            ),
          ),
          itemBuilder: (context, index) {
            return _RemoteImage(
              imageUrl: banners[index].imageUrl,
              fit: BoxFit.cover,
              placeholderColor: Colors.white.withValues(alpha: 0.5),
            );
          },
        ),
      ),
    );
  }
}

class _HotVarietyGrid extends StatelessWidget {
  const _HotVarietyGrid({required this.varieties});

  final List<HomeVarietyItem> varieties;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          SizedBox(
            height: 24,
            child: Row(
              children: [
                const Text(
                  '热门宠物',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Text(
                      '查看更多',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF999999),
                      ),
                    ),
                    const SizedBox(width: 2),
                    SvgPicture.asset(
                      'assets/images/btn_more_normal.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF999999),
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 24) / 4;
              return Wrap(
                spacing: 8,
                runSpacing: 12,
                children: [
                  for (final item in varieties)
                    SizedBox(
                      width: itemWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 58,
                              height: 58,
                              child: _RemoteImage(
                                imageUrl: item.iconUrl,
                                fit: BoxFit.cover,
                                placeholderColor: const Color(0xFFF7F2ED),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final HomeProductItem product;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 2),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: _RemoteImage(
                    imageUrl: product.mainImage,
                    fit: BoxFit.cover,
                    placeholderColor: const Color(0xFFF7F2ED),
                  ),
                ),
                if (product.isExcellence)
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '优选',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '¥${_formatPrice(product.price)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF6B6B),
                        ),
                      ),
                      if (product.originPrice > product.price) ...[
                        const SizedBox(width: 8),
                        Text(
                          '¥${_formatPrice(product.originPrice)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (product.isShipFree)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF4ECDC4),
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Text(
                            '包邮',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF4ECDC4),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          product.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoteImage extends StatelessWidget {
  const _RemoteImage({
    required this.imageUrl,
    required this.fit,
    required this.placeholderColor,
  });

  final String imageUrl;
  final BoxFit fit;
  final Color placeholderColor;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _ImagePlaceholder(color: placeholderColor);
    }

    return Image.network(
      imageUrl,
      fit: fit,
      errorBuilder: (_, __, ___) {
        return _ImagePlaceholder(color: placeholderColor);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return _ImagePlaceholder(color: placeholderColor);
      },
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: const Center(
        child: Icon(
          Icons.pets_outlined,
          size: 22,
          color: Color(0xFFB7A899),
        ),
      ),
    );
  }
}

class _HomeStatusPanel extends StatelessWidget {
  const _HomeStatusPanel({
    required this.loading,
    required this.errorMessage,
    required this.onRetry,
  });

  final bool loading;
  final String? errorMessage;
  final Future<bool> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (errorMessage != null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                errorMessage!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => onRetry(),
                child: const Text('重新加载'),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox(
      height: 200,
      child: Center(
        child: Text(
          '暂无商品',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

String _formatPrice(double value) {
  if (value == value.truncateToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2);
}
