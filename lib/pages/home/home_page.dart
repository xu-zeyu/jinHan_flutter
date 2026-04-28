import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/constants/app_colors.dart';
import '../../core/api/home_repository.dart';
import '../../shared/models/home_models.dart';
import 'widgets/home_hero_section.dart';
import 'widgets/home_product_widgets.dart';
import 'widgets/home_refresh_widgets.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/home_status_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final RefreshController _refreshController = RefreshController();
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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _handleScroll(double offset) {
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
      if (mounted && _scrollY <= 0) {
        setState(_resetNavState);
      }
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) {
      return false;
    }

    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) {
      return false;
    }

    _handleScroll(metrics.pixels);
    return false;
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
    super.build(context);
    final topSafeHeight = MediaQuery.paddingOf(context).top;
    final navBarHeight = topSafeHeight + 44;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.contentBackground,
      ),
      child: Scaffold(
        backgroundColor: AppColors.contentBackground,
        body: NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: Stack(
            children: [
              RefreshConfiguration(
                enableScrollWhenRefreshCompleted: true,
                enableBallisticRefresh: false,
                enableBallisticLoad: false,
                child: SmartRefresher.builder(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  builder: (context, physics) => CustomScrollView(
                    primary: true,
                    physics: physics,
                    slivers: _buildSlivers(
                      navBarHeight: navBarHeight,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: HomeSearchBar(
                  topSafeHeight: topSafeHeight,
                  bgOpacity: _bgOpacity,
                  translateX: _translateX,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSlivers({
    required double navBarHeight,
  }) {
    if (_isInitialLoading) {
      return [
        const HomeRefreshHeader(),
        const SliverToBoxAdapter(
          child: HomeSkeletonView(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
        const HomeLoadMoreFooter(),
      ];
    }

    return [
      const HomeRefreshHeader(),
      SliverToBoxAdapter(
        child: HomeHeroSection(
          navBarHeight: navBarHeight,
          banners: _bannerList,
          varieties: _varietyList,
        ),
      ),
      if (_productList.isNotEmpty)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childCount: _productList.length,
            itemBuilder: (context, index) {
              return HomeProductCard(product: _productList[index]);
            },
          ),
        )
      else
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: HomeStatusPanel(
              errorMessage: _errorMessage,
              onRetry: () => _loadInitialData(),
            ),
          ),
        ),
      const SliverToBoxAdapter(
        child: SizedBox(height: 16),
      ),
      const HomeLoadMoreFooter(),
    ];
  }
}
