import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/items/items_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/map/map_screen.dart';
import '../app.dart';

class AppRoutes {
  static const String home = '/';
  static const String items = '/items';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String map = '/map';
  
  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: items,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ItemsScreen(),
            ),
          ),
          GoRoute(
            path: chat,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatScreen(),
            ),
          ),
          GoRoute(
            path: profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
          GoRoute(
            path: map,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MapScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}