import 'package:go_router/go_router.dart';

import '../../pages/root_page/root_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const RootPage(),
    ),
  ],
);
