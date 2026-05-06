/// 商家地区模型，供热门地区和地区弹窗复用。
class BusinessRegionModel {
  const BusinessRegionModel({
    required this.code,
    required this.name,
  });

  final String code;
  final String name;
}

/// 商家筛选标签模型，负责描述排序维度。
class BusinessFilterTabModel {
  const BusinessFilterTabModel({
    required this.code,
    required this.label,
  });

  final String code;
  final String label;
}

/// 商家推荐商品模型，供商家列表卡片展示商品预览。
class BusinessProductModel {
  const BusinessProductModel({
    required this.name,
    required this.priceLabel,
    required this.tag,
  });

  final String name;
  final String priceLabel;
  final String tag;
}

/// 商家展示模型，聚合推荐商家与列表卡片需要的字段。
class BusinessMerchantModel {
  const BusinessMerchantModel({
    required this.code,
    required this.regionCode,
    required this.name,
    required this.cityLabel,
    required this.avatarLabel,
    required this.levelLabel,
    required this.onSaleCount,
    required this.reviewCount,
    required this.positiveRate,
    required this.rating,
    required this.transactionCount,
    required this.distanceKm,
    required this.products,
  });

  final String code;
  final String regionCode;
  final String name;
  final String cityLabel;
  final String avatarLabel;
  final String levelLabel;
  final int onSaleCount;
  final int reviewCount;
  final int positiveRate;
  final double rating;
  final int transactionCount;
  final double distanceKm;
  final List<BusinessProductModel> products;
}
