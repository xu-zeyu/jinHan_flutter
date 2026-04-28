import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class JinHanApp extends StatelessWidget {
  const JinHanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
