import 'package:game_shelf/features/explore/explore_screen.dart';
import 'package:game_shelf/features/game_details/game_details_screen.dart';
import 'package:game_shelf/features/library/library_screen.dart';
import 'package:game_shelf/features/search/search_screen.dart';
import 'package:game_shelf/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/explore/game_list_screen.dart';
import '../main.dart';

enum GameListKind { trending, popular, recentlyReleased }

final appShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'app shell');

final GoRouter router = GoRouter(
  initialLocation: '/explore',
  redirect: (BuildContext context, GoRouterState state) {
    final String location = state.uri.path;
    if (location.isEmpty || location == '/') {
      return '/explore';
    }
    return null;
  },
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: appShellNavigatorKey,
      builder: (context, state, child) {
        return MainScaffold(
          selectedIndex: RouterUtils.getIndexByPath(state.uri.path),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/explore',
          name: 'explore',
          builder: (BuildContext context, GoRouterState state) {
            return const ExploreScreen();
          },
          routes: [
            GoRoute(
              path: 'games/:kind',
              name: 'game-list',
              builder: (context, state) {
                final kind = GameListKind.values.byName(
                  state.pathParameters['kind']!,
                );
                return GameListScreen(kind: kind);
              },
            ),
            GoRoute(
              path: 'game/:id',
              name: 'game-details',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id']!);
                if (id == null) return const ExploreScreen();

                return GameDetailsScreen(id: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra;
            final String? search = extra is Map<String, dynamic>
                ? extra['search'] as String?
                : null;
            return SearchScreen(search: search);
          },
        ),
        GoRoute(
          path: '/library',
          name: 'library',
          builder: (BuildContext context, GoRouterState state) {
            return const LibraryScreen();
          },
        ),
      
      ],
    ),
  ],
);
