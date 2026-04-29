import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../api/home_repository.dart';
import '../network/request_manager.dart';
import '../storage/token_manager.dart';
import 'theme_provider.dart';

/// Root provider scope for app-wide dependencies.
class ProviderScope extends StatelessWidget {
  const ProviderScope({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokenManager = TokenManager.instance;
    final requestManager = RequestManager(tokenManager: tokenManager);
    final homeRepository = HomeRepository(requestManager: requestManager);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TokenManager>.value(value: tokenManager),
        Provider<RequestManager>.value(value: requestManager),
        Provider<HomeRepository>.value(value: homeRepository),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider()..initialize(),
        ),
      ],
      child: child,
    );
  }
}
