import '../../core/services/request.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/json_utils.dart';

/// 用户中心使用的聚合用户信息模型。
class UserProfileModel {
  const UserProfileModel({
    required this.userId,
    required this.username,
    required this.phone,
    required this.statusCode,
    required this.statusLabel,
    required this.createdTime,
    required this.updatedTime,
    required this.lastLoginAt,
    required this.idNumber,
    required this.genderCode,
    required this.genderLabel,
    required this.petList,
  });

  final int userId;
  final String username;
  final String phone;
  final String statusCode;
  final String statusLabel;
  final DateTime? createdTime;
  final DateTime? updatedTime;
  final DateTime? lastLoginAt;
  final String idNumber;
  final String genderCode;
  final String genderLabel;
  final List<UserPetModel> petList;

  String get displayName {
    if (username.isNotEmpty) {
      return username;
    }
    if (maskedPhone.isNotEmpty) {
      return maskedPhone;
    }
    return 'JinHan 用户';
  }

  String get maskedPhone {
    if (phone.length < 7) {
      return phone;
    }
    return '${phone.substring(0, 3)}****${phone.substring(phone.length - 4)}';
  }

  String get displayGender => genderLabel.isNotEmpty ? genderLabel : '未完善';

  String get displayStatus => statusLabel.isNotEmpty ? statusLabel : '未完善';

  String get identitySummary {
    if (idNumber.length <= 4) {
      return idNumber;
    }
    return '****${idNumber.substring(idNumber.length - 4)}';
  }

  int get petCount => petList.length;

  String get petSummary => petCount == 0 ? '暂无爱宠档案' : '已同步 $petCount 只爱宠';

  /// 解析 `/user` 聚合接口返回。
  factory UserProfileModel.fromJson(
    Map<String, dynamic> json,
    RequestManager requestManager,
  ) {
    final List<UserPetModel> petList = JsonUtils.asListOfMap(json['petList'])
        .map((item) => UserPetModel.fromJson(item, requestManager))
        .toList();

    return UserProfileModel(
      userId: JsonUtils.asInt(json['userId']),
      username: JsonUtils.asString(json['username']),
      phone: JsonUtils.asString(json['phone']),
      statusCode: _readEnumCode(json['status']),
      statusLabel: _enumLabel(
        json['status'],
        fallbackLabels: const <String, String>{
          'UNAUTHENTICATED': '未认证',
          'UNDER_REVIEW': '审核中',
          'COMPLETED': '已认证',
          'REJECTED': '已拒绝',
        },
      ),
      createdTime: AppDateUtils.tryParse(json['createdTime']),
      updatedTime: AppDateUtils.tryParse(json['updatedTime']),
      lastLoginAt: AppDateUtils.tryParse(json['lastLoginAt']),
      idNumber: JsonUtils.asString(json['idNumber']),
      genderCode: _readEnumCode(json['gender']),
      genderLabel: _enumLabel(
        json['gender'],
        fallbackLabels: const <String, String>{
          'M': '男',
          'F': '女',
        },
      ),
      petList: petList,
    );
  }
}

/// 我的页面使用的用户爱宠模型。
class UserPetModel {
  const UserPetModel({
    required this.id,
    required this.petName,
    required this.petTypeCode,
    required this.petTypeLabel,
    required this.varietyId,
    required this.genderCode,
    required this.genderLabel,
    required this.birthday,
    required this.avatarUrl,
    required this.remark,
    required this.createdTime,
    required this.updatedTime,
  });

  final int id;
  final String petName;
  final String petTypeCode;
  final String petTypeLabel;
  final int varietyId;
  final String genderCode;
  final String genderLabel;
  final DateTime? birthday;
  final String avatarUrl;
  final String remark;
  final DateTime? createdTime;
  final DateTime? updatedTime;

  String get displayName => petName.isNotEmpty ? petName : '未命名爱宠';

  String get displayType => petTypeLabel.isNotEmpty ? petTypeLabel : '未分类';

  String get displayGender => genderLabel.isNotEmpty ? genderLabel : '未填写';

  String get birthdayText =>
      AppDateUtils.formatDate(birthday, fallback: '生日未完善');

  String get ageText {
    if (birthday == null) {
      return '年龄未完善';
    }

    final DateTime today = AppDateUtils.startOfDay(AppDateUtils.now());
    final DateTime birthDay = AppDateUtils.startOfDay(birthday!);
    int monthCount =
        (today.year - birthDay.year) * 12 + today.month - birthDay.month;
    if (today.day < birthDay.day) {
      monthCount -= 1;
    }

    if (monthCount <= 0) {
      return '1 个月内';
    }

    final int year = monthCount ~/ 12;
    final int month = monthCount % 12;
    if (year <= 0) {
      return '$month 个月';
    }
    if (month == 0) {
      return '$year 岁';
    }
    return '$year 岁 $month 个月';
  }

  String get remarkText => remark.isNotEmpty ? remark : '暂无备注';

  /// 解析宠物聚合数据。
  factory UserPetModel.fromJson(
    Map<String, dynamic> json,
    RequestManager requestManager,
  ) {
    final String avatar = JsonUtils.asString(json['avatar']);
    return UserPetModel(
      id: JsonUtils.asInt(json['id']),
      petName: JsonUtils.asString(json['petName']),
      petTypeCode: _readEnumCode(json['petType']),
      petTypeLabel: _enumLabel(
        json['petType'],
        fallbackLabels: const <String, String>{
          'CAT': '猫',
          'DOG': '狗',
          'BIRD': '鸟类',
          'RABBIT': '兔子',
          'OTHER': '其他',
        },
      ),
      varietyId: JsonUtils.asInt(json['varietyId']),
      genderCode: _readEnumCode(json['gender']),
      genderLabel: _enumLabel(
        json['gender'],
        fallbackLabels: const <String, String>{
          'M': '男',
          'F': '女',
        },
      ),
      birthday: AppDateUtils.tryParse(json['birthday']),
      avatarUrl: avatar.isEmpty ? '' : requestManager.resolveUrl(avatar),
      remark: JsonUtils.asString(json['remark']),
      createdTime: AppDateUtils.tryParse(json['createdTime']),
      updatedTime: AppDateUtils.tryParse(json['updatedTime']),
    );
  }
}

String _readEnumCode(dynamic value) {
  final Map<String, dynamic> mapValue = JsonUtils.asMap(value);
  if (mapValue.isNotEmpty) {
    return JsonUtils.asString(
      mapValue['code'],
      fallback: JsonUtils.asString(
        mapValue['name'],
        fallback: JsonUtils.asString(
          mapValue['value'],
          fallback: JsonUtils.asString(mapValue['description']),
        ),
      ),
    ).toUpperCase();
  }

  return JsonUtils.asString(value).toUpperCase();
}

String _enumLabel(
  dynamic value, {
  required Map<String, String> fallbackLabels,
}) {
  final Map<String, dynamic> mapValue = JsonUtils.asMap(value);
  if (mapValue.isNotEmpty) {
    final String label = JsonUtils.asString(
      mapValue['description'],
      fallback: JsonUtils.asString(
        mapValue['label'],
        fallback: JsonUtils.asString(mapValue['desc']),
      ),
    );
    if (label.isNotEmpty) {
      return label;
    }
  }

  final String code = _readEnumCode(value);
  return fallbackLabels[code] ?? JsonUtils.asString(value);
}
