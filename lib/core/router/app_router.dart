import 'package:go_router/go_router.dart';

import '../../pages/login/login_page.dart';
import '../../pages/root_page/root_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const RootPage(),
    ),
  ],
);
