import '../../core/services/request.dart';
import '../../core/utils/json_utils.dart';
import '../../shared/models/home_models.dart';

/// Repository for home page APIs. Keeps endpoint parsing out of the UI layer.
class HomeRepository {
  HomeRepository({RequestManager? requestManager})
      : _requestManager = requestManager ?? RequestManager();

  final RequestManager _requestManager;

  Future<List<HomeBannerItem>> fetchBannerList() async {
    final response = await _requestManager.get<Map<String, dynamic>>(
      '/banner/list',
      queryParameters: const <String, dynamic>{'page': 1, 'size': 10},
      decoder: JsonUtils.asMap,
    );
    final records = JsonUtils.asListOfMap(
      response.requireData(fallbackMessage: '轮播图数据为空')['records'],
    );
    return records
        .map(
          (item) => HomeBannerItem.fromJson(
            Map<String, dynamic>.from(item),
            _requestManager,
          ),
        )
        .toList();
  }

  Future<List<HomeVarietyItem>> fetchHotVarietyList() async {
    final response = await _requestManager.get<List<Map<String, dynamic>>>(
      '/variety/hot',
      decoder: JsonUtils.asListOfMap,
    );
    final records = response.requireData(fallbackMessage: '品种数据为空');
    return records
        .map(
          (item) => HomeVarietyItem.fromJson(
            Map<String, dynamic>.from(item),
            _requestManager,
          ),
        )
        .toList();
  }

  Future<HomeProductPage> fetchProductPage({
    required int page,
    int size = 10,
  }) async {
    final response = await _requestManager.get<Map<String, dynamic>>(
      '/product/page',
      queryParameters: <String, dynamic>{'page': page, 'size': size},
      decoder: JsonUtils.asMap,
    );
    return HomeProductPage.fromJson(
      response.requireData(fallbackMessage: '商品列表数据为空'),
      _requestManager,
    );
  }
}
