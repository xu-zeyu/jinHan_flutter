import 'package:flutter/foundation.dart';

import '../models/business_page_model.dart';

/// 商家页面状态提供者，负责地区切换、排序筛选与列表数据编排。
class BusinessPageProvider extends ChangeNotifier {
  static const String _currentRegionCode = 'sz_shenzhen';
  static const String _defaultSortCode = 'top_rated';
  static const String _nationwideRegionCode = 'cn_national';
  static const int _hotRegionCount = 8;
  static const int _recommendedMerchantCount = 8;

  static const List<BusinessRegionModel> _regions = <BusinessRegionModel>[
    BusinessRegionModel(code: 'sz_shenzhen', name: '深圳'),
    BusinessRegionModel(code: 'cn_national', name: '全国'),
    BusinessRegionModel(code: 'bj_beijing', name: '北京'),
    BusinessRegionModel(code: 'tj_tianjin', name: '天津'),
    BusinessRegionModel(code: 'sy_shenyang', name: '沈阳'),
    BusinessRegionModel(code: 'sh_shanghai', name: '上海'),
    BusinessRegionModel(code: 'hz_hangzhou', name: '杭州'),
    BusinessRegionModel(code: 'jn_jinan', name: '济南'),
    BusinessRegionModel(code: 'gz_guangzhou', name: '广州'),
    BusinessRegionModel(code: 'nj_nanjing', name: '南京'),
    BusinessRegionModel(code: 'xy_xiangyang', name: '襄阳'),
    BusinessRegionModel(code: 'km_kunming', name: '昆明'),
  ];

  static const List<BusinessFilterTabModel> _filterTabs =
      <BusinessFilterTabModel>[
    BusinessFilterTabModel(code: 'platform_featured', label: '平台优选'),
    BusinessFilterTabModel(code: 'most_deals', label: '交易最多'),
    BusinessFilterTabModel(code: 'top_rated', label: '星级最高'),
    BusinessFilterTabModel(code: 'most_pets', label: '宠物最多'),
  ];

  static const List<BusinessMerchantModel> _merchants = <BusinessMerchantModel>[
    BusinessMerchantModel(
      code: 'm_sz_baobei',
      regionCode: 'sz_shenzhen',
      name: '宝贝萌宠陪伴一生无忧售后',
      cityLabel: '广东省 深圳市',
      avatarLabel: '萌宠',
      levelLabel: '优选商家',
      onSaleCount: 86,
      reviewCount: 217,
      positiveRate: 99,
      rating: 5,
      transactionCount: 221,
      distanceKm: 1.2,
      products: <BusinessProductModel>[
        BusinessProductModel(name: '英短蓝猫', priceLabel: '¥3200', tag: '包邮'),
        BusinessProductModel(name: '蓝白弟弟', priceLabel: '¥3600', tag: '包邮'),
        BusinessProductModel(name: '银渐层妹妹', priceLabel: '¥4100', tag: '包邮'),
      ],
    ),
    BusinessMerchantModel(
      code: 'm_sz_deepbay',
      regionCode: 'sz_shenzhen',
      name: '深湾宠物甄选馆',
      cityLabel: '广东省 深圳市',
      avatarLabel: '深湾',
      levelLabel: '优选商家',
      onSaleCount: 64,
      reviewCount: 182,
      positiveRate: 98,
      rating: 4.9,
      transactionCount: 198,
      distanceKm: 2.4,
      products: <BusinessProductModel>[
        BusinessProductModel(name: '布偶妹妹', priceLabel: '¥4800', tag: '包邮'),
        BusinessProductModel(name: '拿破仑弟弟', priceLabel: '¥4300', tag: '包邮'),
        BusinessProductModel(name: '矮脚银点', priceLabel: '¥5200', tag: '包邮'),
      ],
    ),
    BusinessMerchantModel(
      code: 'm_sz_nanmei',
      regionCode: 'sz_shenzhen',
      name: '南美喵汪会所',
      cityLabel: '广东省 深圳市',
      avatarLabel: '喵汪',
      levelLabel: '优选商家',
      onSaleCount: 52,
      reviewCount: 149,
      positiveRate: 97,
      rating: 4.8,
      transactionCount: 176,
      distanceKm: 3.1,
      products: <BusinessProductModel>[
        BusinessProductModel(name: '金吉拉妹妹', priceLabel: '¥3500', tag: '包邮'),
        BusinessProductModel(name: '缅因幼猫', priceLabel: '¥5600', tag: '包邮'),
        BusinessProductModel(name: '柴犬弟弟', priceLabel: '¥6200', tag: '包邮'),
      ],
    ),
    BusinessMerchantModel(
      code: 'm_bj_maodou',
      regionCode: 'bj_beijing',
      name: '猫兜宠物猫舍',
      cityLabel: '北京市 朝阳区',
      avatarLabel: '猫兜',
      levelLabel: '优选商家',
      onSaleCount: 73,
      reviewCount: 208,
      positiveRate: 99,
      rating: 5,
      transactionCount: 238,
      distanceKm: 4.6,
      products: <BusinessProductModel>[
        BusinessProductModel(name: '银渐层弟弟', priceLabel: '¥4200', tag: '包邮'),
        BusinessProductModel(name: '英短乳白', priceLabel: '¥3900', tag: '包邮'),
        BusinessProductModel(name: '德文卷毛', priceLabel: '¥6800', tag: '包邮'),
      ],
    ),
    BusinessMerchantModel(
      code: 'm_xy_chaoyi',
      regionCode: 'xy_xiangyang',
      name: '潮异酷宠物',
      cityLabel: '湖北省 襄阳市',
      avatarLabel: '潮异',
      levelLabel: '优选商家',
      onSaleCount: 57,
      reviewCount: 163,
      positiveRate: 98,
      rating: 4.9,
      transactionCount: 184,
      distanceKm: 5.8,
      products: <BusinessProductModel>[
        BusinessProductModel(name: '孟买猫弟弟', priceLabel: '¥3300', tag: '包邮'),
        BusinessProductModel(name: '德牧幼犬', priceLabel: '¥5400', tag: '包邮'),
        BusinessProductModel(name: '加菲妹妹', priceLabel: '¥4500', tag: '包邮'),
      ],
    ),
    BusinessMerchantModel(
      code: 'm_gz_bloodline',
      regionCode: 'gz_guangzhou',
      name: '血统精品萌宠',
      cityLabel: '广东省 广州市',
      avatarLabel: '血统',
      levelLabel: '优选商家',
      onSaleCount: 61,
      reviewCount: 171,
      positiveRate: 98,
      rating: 4.9,
      transactionCount: 190,
      distanceKm: 6.2,
      products: <BusinessProductModel>[
        BusinessProductModel(name: '萨摩耶妹妹', priceLabel: '¥5800', tag: '包邮'),
        BusinessProductModel(name: '银狐犬弟弟', priceLabel: '¥3900', tag: '包邮'),
        BusinessProductModel(name: '阿拉斯加', priceLabel: '¥6600', tag: '包邮'),
      ],
    ),
    BusinessMerchantModel(
      code: 'm_nj_highend',
      regionCode: 'nj_nanjing',
      name: '高端精品宠物',
      cityLabel: '江苏省 南京市',
      avatarLabel: '高端',
      levelLabel: '优选商家',
      onSaleCount: 48,
      reviewCount: 136,
      positiveRate: 97,
      rating: 4.8,
      transactionCount: 168,
      distanceKm: 7.4,
      products: <BusinessProductModel>[
        BusinessProductModel(name: '银点妹妹', priceLabel: '¥4000', tag: '包邮'),
        BusinessProductModel(name: '布偶海豹色', priceLabel: '¥5300', tag: '包邮'),
        BusinessProductModel(name: '柯基弟弟', priceLabel: '¥4700', tag: '包邮'),
      ],
    ),
    BusinessMerchantModel(
      code: 'm_jn_duole',
      regionCode: 'jn_jinan',
      name: '宠乐多宠物生活',
      cityLabel: '山东省 济南市',
      avatarLabel: '宠乐',
      levelLabel: '优选商家',
      onSaleCount: 43,
      reviewCount: 128,
      positiveRate: 97,
      rating: 4.8,
      transactionCount: 152,
      distanceKm: 8.1,
      products: <BusinessProductModel>[
        BusinessProductModel(name: '美短虎斑', priceLabel: '¥2800', tag: '包邮'),
        BusinessProductModel(name: '英短蓝白', priceLabel: '¥3400', tag: '包邮'),
        BusinessProductModel(name: '比熊弟弟', priceLabel: '¥3600', tag: '包邮'),
      ],
    ),
    BusinessMerchantModel(
      code: 'm_sh_xinyu',
      regionCode: 'sh_shanghai',
      name: '信誉钻石店铺',
      cityLabel: '上海市 闵行区',
      avatarLabel: '信誉',
      levelLabel: '优选商家',
      onSaleCount: 58,
      reviewCount: 186,
      positiveRate: 99,
      rating: 4.9,
      transactionCount: 205,
      distanceKm: 3.7,
      products: <BusinessProductModel>[
        BusinessProductModel(name: '暹罗弟弟', priceLabel: '¥3100', tag: '包邮'),
        BusinessProductModel(name: '蓝金妹妹', priceLabel: '¥4700', tag: '包邮'),
        BusinessProductModel(name: '曼基康幼猫', priceLabel: '¥5800', tag: '包邮'),
      ],
    ),
    BusinessMerchantModel(
      code: 'm_km_miaomiao',
      regionCode: 'km_kunming',
      name: '喵喵猫屋',
      cityLabel: '云南省 昆明市',
      avatarLabel: '喵喵',
      levelLabel: '优选商家',
      onSaleCount: 39,
      reviewCount: 121,
      positiveRate: 96,
      rating: 4.7,
      transactionCount: 144,
      distanceKm: 9.4,
      products: <BusinessProductModel>[
        BusinessProductModel(name: '长毛银点', priceLabel: '¥2900', tag: '包邮'),
        BusinessProductModel(name: '拿破仑妹妹', priceLabel: '¥4600', tag: '包邮'),
        BusinessProductModel(name: '起司幼猫', priceLabel: '¥3300', tag: '包邮'),
      ],
    ),
    BusinessMerchantModel(
      code: 'm_hz_youshe',
      regionCode: 'hz_hangzhou',
      name: '西湖萌宠优舍',
      cityLabel: '浙江省 杭州市',
      avatarLabel: '优舍',
      levelLabel: '优选商家',
      onSaleCount: 46,
      reviewCount: 133,
      positiveRate: 97,
      rating: 4.8,
      transactionCount: 158,
      distanceKm: 5.1,
      products: <BusinessProductModel>[
        BusinessProductModel(name: '银渐层妹妹', priceLabel: '¥3700', tag: '包邮'),
        BusinessProductModel(name: '布偶双色', priceLabel: '¥5200', tag: '包邮'),
        BusinessProductModel(name: '约克夏幼犬', priceLabel: '¥4100', tag: '包邮'),
      ],
    ),
  ];

  String _selectedRegionCode = _currentRegionCode;
  String _selectedSortCode = _defaultSortCode;
  bool _initialized = false;

  String get currentRegionCode => _currentRegionCode;

  String get selectedRegionCode => _selectedRegionCode;

  String get selectedSortCode => _selectedSortCode;

  BusinessRegionModel get currentRegion => _findRegion(_currentRegionCode);

  BusinessRegionModel get selectedRegion => _findRegion(_selectedRegionCode);

  List<BusinessRegionModel> get allRegions => _regions;

  List<BusinessRegionModel> get hotRegions {
    return _regions.take(_hotRegionCount).toList(growable: false);
  }

  List<BusinessFilterTabModel> get filterTabs => _filterTabs;

  List<BusinessMerchantModel> get recommendedMerchants {
    final List<BusinessMerchantModel> result = List<BusinessMerchantModel>.of(
      _merchants,
    )..sort(_compareRecommended);
    return result.take(_recommendedMerchantCount).toList(growable: false);
  }

  List<BusinessMerchantModel> get merchants {
    final List<BusinessMerchantModel> result =
        _filterByRegion(_selectedRegionCode)..sort(_compareBySelectedSort);
    return result;
  }

  /// 初始化页面默认筛选状态。
  void initialize() {
    if (_initialized) {
      return;
    }
    _initialized = true;
  }

  /// 根据地区编码切换当前筛选地区。
  void selectRegion(String code) {
    if (_selectedRegionCode == code || !_hasRegion(code)) {
      return;
    }
    _selectedRegionCode = code;
    notifyListeners();
  }

  /// 根据排序编码切换商家列表的排序方式。
  void selectSort(String code) {
    if (_selectedSortCode == code || !_hasSort(code)) {
      return;
    }
    _selectedSortCode = code;
    notifyListeners();
  }

  List<BusinessMerchantModel> _filterByRegion(String regionCode) {
    if (regionCode == _nationwideRegionCode) {
      return List<BusinessMerchantModel>.of(_merchants);
    }

    return _merchants
        .where((BusinessMerchantModel item) => item.regionCode == regionCode)
        .toList(growable: false);
  }

  BusinessRegionModel _findRegion(String code) {
    return _regions.firstWhere(
      (BusinessRegionModel item) => item.code == code,
      orElse: () => _regions.first,
    );
  }

  bool _hasRegion(String code) {
    return _regions.any((BusinessRegionModel item) => item.code == code);
  }

  bool _hasSort(String code) {
    return _filterTabs.any((BusinessFilterTabModel item) => item.code == code);
  }

  int _compareRecommended(
    BusinessMerchantModel left,
    BusinessMerchantModel right,
  ) {
    final int ratingCompare = right.rating.compareTo(left.rating);
    if (ratingCompare != 0) {
      return ratingCompare;
    }
    return right.transactionCount.compareTo(left.transactionCount);
  }

  int _compareBySelectedSort(
    BusinessMerchantModel left,
    BusinessMerchantModel right,
  ) {
    switch (_selectedSortCode) {
      case 'platform_featured':
        return _compareFeatured(left, right);
      case 'most_deals':
        return _compareMostDeals(left, right);
      case 'most_pets':
        return _compareMostPets(left, right);
      case 'top_rated':
      default:
        return _compareTopRated(left, right);
    }
  }

  int _compareFeatured(
    BusinessMerchantModel left,
    BusinessMerchantModel right,
  ) {
    final int positiveRateCompare =
        right.positiveRate.compareTo(left.positiveRate);
    if (positiveRateCompare != 0) {
      return positiveRateCompare;
    }
    return _compareTopRated(left, right);
  }

  int _compareMostDeals(
    BusinessMerchantModel left,
    BusinessMerchantModel right,
  ) {
    final int dealsCompare =
        right.transactionCount.compareTo(left.transactionCount);
    if (dealsCompare != 0) {
      return dealsCompare;
    }
    return right.rating.compareTo(left.rating);
  }

  int _compareTopRated(
    BusinessMerchantModel left,
    BusinessMerchantModel right,
  ) {
    final int ratingCompare = right.rating.compareTo(left.rating);
    if (ratingCompare != 0) {
      return ratingCompare;
    }
    return right.reviewCount.compareTo(left.reviewCount);
  }

  int _compareMostPets(
    BusinessMerchantModel left,
    BusinessMerchantModel right,
  ) {
    final int petCountCompare = right.onSaleCount.compareTo(left.onSaleCount);
    if (petCountCompare != 0) {
      return petCountCompare;
    }
    return right.transactionCount.compareTo(left.transactionCount);
  }
}
