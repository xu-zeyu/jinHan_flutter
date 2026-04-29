import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../storage/token_manager.dart';
import '../utils/permission_utils.dart';

/// Collects startup work that must finish before the widget tree is built.
class AppBootstrap {
  const AppBootstrap._();

  static Future<void> initialize() async {
    await dotenv.load(fileName: kReleaseMode ? '.env.prod' : '.env.dev');
    await TokenManager.instance.init();
    await PermissionUtils.requestAllCommonPermissions();
  }
}
