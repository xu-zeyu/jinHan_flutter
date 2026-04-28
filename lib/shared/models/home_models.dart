import 'dart:convert';

import '../../core/services/request.dart';

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
      id: _asInt(json['id']),
      imageUrl: requestManager.resolveUrl(_asString(json['url'])),
      link: _asString(json['link']),
      title: _asString(json['title']),
      description: _asString(json['description']),
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
      id: _asInt(json['id']),
      name: _asString(json['name']),
      iconUrl: requestManager.resolveUrl(_asString(json['iconUrl'])),
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
    final rawRecords = json['records'];
    final records = rawRecords is List
        ? rawRecords
            .map(
              (item) => HomeProductItem.fromJson(
                Map<String, dynamic>.from(item as Map),
                requestManager,
              ),
            )
            .toList()
        : const <HomeProductItem>[];

    return HomeProductPage(
      records: records,
      current: _asInt(json['current'], fallback: 1),
      total: _asInt(json['total']),
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
    final variety = json['variety'];
    final varietyMap = variety is Map<String, dynamic>
        ? variety
        : variety is Map
            ? Map<String, dynamic>.from(variety)
            : const <String, dynamic>{};

    final images = _parseImageList(json['images']);
    final mainImage = _asString(json['mainImage']);
    final resolvedImage = mainImage.isNotEmpty
        ? requestManager.resolveUrl(mainImage)
        : images.isNotEmpty
            ? requestManager.resolveUrl(images.first)
            : '';

    return HomeProductItem(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      title: _asString(json['title']),
      mainImage: resolvedImage,
      price: _asDouble(json['price']),
      originPrice: _asDouble(json['originPrice']),
      isExcellence: _asInt(json['isExcellence']) == 1,
      isShipFree: _asInt(json['isShipFree']) == 1,
      varietyName: _asString(varietyMap['name']),
    );
  }
}

double _asDouble(dynamic value, {double fallback = 0}) {
  if (value is num) {
    return value.toDouble();
  }

  if (value == null) {
    return fallback;
  }

  return double.tryParse(value.toString()) ?? fallback;
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value == null) {
    return fallback;
  }

  return int.tryParse(value.toString()) ?? fallback;
}

String _asString(dynamic value) {
  if (value == null) {
    return '';
  }

  return value.toString().trim();
}

List<String> _parseImageList(dynamic value) {
  if (value is List) {
    return value.map(_asString).where((item) => item.isNotEmpty).toList();
  }

  final raw = _asString(value);
  if (raw.isEmpty) {
    return const <String>[];
  }

  try {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded.map(_asString).where((item) => item.isNotEmpty).toList();
    }
  } catch (_) {
    return <String>[raw];
  }

  return const <String>[];
}
