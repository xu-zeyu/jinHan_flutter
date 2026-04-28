import '../../core/services/request.dart';
import 'home_models.dart';

class HomeRepository {
  HomeRepository({RequestManager? requestManager})
      : _requestManager = requestManager ?? RequestManager();

  final RequestManager _requestManager;

  Future<List<HomeBannerItem>> fetchBannerList() async {
    final root = await _get(
      '/banner/list',
      queryParameters: const <String, dynamic>{'page': 1, 'size': 10},
    );
    final pageData = _readMap(root['data']);
    final records = _readList(pageData['records']);
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
    final root = await _get('/variety/hot');
    final records = _readList(root['data']);
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
    final root = await _get(
      '/product/page',
      queryParameters: <String, dynamic>{'page': page, 'size': size},
    );
    return HomeProductPage.fromJson(_readMap(root['data']), _requestManager);
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _requestManager.request<dynamic>(
      path,
      queryParameters: queryParameters,
    );
    final root = _readMap(response.data);
    final code = root['code']?.toString();
    if (code != null && code != '200') {
      throw Exception(root['msg']?.toString() ?? 'Request failed: $path');
    }
    return root;
  }

  Map<String, dynamic> _readMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _readList(dynamic value) {
    if (value is! List) {
      return const <Map<String, dynamic>>[];
    }

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
