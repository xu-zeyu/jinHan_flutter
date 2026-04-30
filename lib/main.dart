import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/providers/provider_scope.dart';
import 'core/storage/token_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: kReleaseMode ? '.env.prod' : '.env.dev');
  await TokenManager.instance.init();
  runApp(
    const ProviderScope(
      child: JinHanApp(),
    ),
  );
}
