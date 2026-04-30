import '../services/request.dart';
import '../utils/json_utils.dart';
import '../../shared/models/user_models.dart';

/// 用户相关接口仓储，负责聚合我的页面需要的数据。
class UserRepository {
  UserRepository({RequestManager? requestManager})
      : _requestManager = requestManager ?? RequestManager();

  final RequestManager _requestManager;

  /// 获取当前登录用户的完整资料与宠物列表。
  Future<UserProfileModel> fetchCurrentUserProfile() async {
    final response = await _requestManager.get<Map<String, dynamic>>(
      '/user',
      decoder: JsonUtils.asMap,
    );

    return UserProfileModel.fromJson(
      response.requireData(fallbackMessage: '用户资料为空'),
      _requestManager,
    );
  }
}
