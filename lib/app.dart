import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';

class JinHanApp extends StatelessWidget {
  const JinHanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp.router(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: themeProvider.theme,
          routerConfig: appRouter,
        );
      },
    );
  }
}
