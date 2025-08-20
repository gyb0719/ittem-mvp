import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/items/items_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../app.dart';

class AppRoutes {
  static const String home = '/';
  static const String items = '/items';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String map = '/map';
  static const String login = '/login';
  static const String signup = '/signup';
  
  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      // 인증 관련 라우트 (바텀 네비게이션 없음)
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      
      // 메인 앱 라우트 (바텀 네비게이션 포함)
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