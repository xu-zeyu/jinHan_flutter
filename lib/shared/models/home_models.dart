import '../../core/services/request.dart';
import '../../core/utils/json_utils.dart';

class HomeBannerItem {
  const HomeBannerItem({
    required this.id,
    required this.imageUrl,
    required this.link,
    required this.title,
    required this.description,
  });

  final int id;
  final String imageUrl;
  final String link;
  final String title;
  final String description;

  factory HomeBannerItem.fromJson(
    Map<String, dynamic> json,
    RequestManager requestManager,
  ) {
    return HomeBannerItem(
      id: JsonUtils.asInt(json['id']),
      imageUrl: requestManager.resolveUrl(JsonUtils.asString(json['url'])),
      link: JsonUtils.asString(json['link']),
      title: JsonUtils.asString(json['title']),
      description: JsonUtils.asString(json['description']),
    );
  }
}

class HomeVarietyItem {
  const HomeVarietyItem({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  final int id;
  final String name;
  final String iconUrl;

  factory HomeVarietyItem.fromJson(
    Map<String, dynamic> json,
    RequestManager requestManager,
  ) {
    return HomeVarietyItem(
      id: JsonUtils.asInt(json['id']),
      name: JsonUtils.asString(json['name']),
      iconUrl: requestManager.resolveUrl(JsonUtils.asString(json['iconUrl'])),
    );
  }
}

class HomeProductPage {
  const HomeProductPage({
    required this.records,
    required this.current,
    required this.total,
  });

  final List<HomeProductItem> records;
  final int current;
  final int total;

  bool get hasMore => records.length < total;

  factory HomeProductPage.fromJson(
    Map<String, dynamic> json,
    RequestManager requestManager,
  ) {
    final rawRecords = JsonUtils.asListOfMap(json['records']);
    final records = rawRecords
        .map((item) => HomeProductItem.fromJson(item, requestManager))
        .toList();

    return HomeProductPage(
      records: records,
      current: JsonUtils.asInt(json['current'], fallback: 1),
      total: JsonUtils.asInt(json['total']),
    );
  }
}

class HomeProductItem {
  const HomeProductItem({
    required this.id,
    required this.name,
    required this.title,
    required this.mainImage,
    required this.price,
    required this.originPrice,
    required this.isExcellence,
    required this.isShipFree,
    required this.varietyName,
  });

  final int id;
  final String name;
  final String title;
  final String mainImage;
  final double price;
  final double originPrice;
  final bool isExcellence;
  final bool isShipFree;
  final String varietyName;

  String get displayTitle => title.isNotEmpty ? title : name;

  String get displayName => varietyName.isNotEmpty ? varietyName : name;

  factory HomeProductItem.fromJson(
    Map<String, dynamic> json,
    RequestManager requestManager,
  ) {
    final varietyMap = JsonUtils.asMap(json['variety']);
    final images = _parseImageList(json['images']);
    final mainImage = JsonUtils.asString(json['mainImage']);
    final resolvedImage = mainImage.isNotEmpty
        ? requestManager.resolveUrl(mainImage)
        : images.isNotEmpty
            ? requestManager.resolveUrl(images.first)
            : '';

    return HomeProductItem(
      id: JsonUtils.asInt(json['id']),
      name: JsonUtils.asString(json['name']),
      title: JsonUtils.asString(json['title']),
      mainImage: resolvedImage,
      price: JsonUtils.asDouble(json['price']),
      originPrice: JsonUtils.asDouble(json['originPrice']),
      isExcellence: JsonUtils.asInt(json['isExcellence']) == 1,
      isShipFree: JsonUtils.asInt(json['isShipFree']) == 1,
      varietyName: JsonUtils.asString(varietyMap['name']),
    );
  }
}

List<String> _parseImageList(dynamic value) {
  return JsonUtils.parseStringList(value, fallbackToSingleValue: true);
}
