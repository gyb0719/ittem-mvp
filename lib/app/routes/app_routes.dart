import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/items/items_screen.dart';
import '../../features/items/add_item_screen.dart';
import '../../features/items/item_detail_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../shared/models/item_model.dart';
import '../app.dart';

class AppRoutes {
  static const String home = '/';
  static const String items = '/items';
  static const String addItem = '/add-item';
  static String itemDetail(String id) => '/item/$id';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String map = '/map';
  static const String notifications = '/notifications';
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
      
      // 아이템 등록 (바텀 네비게이션 없음)
      GoRoute(
        path: addItem,
        builder: (context, state) => const AddItemScreen(),
      ),
      
      // 아이템 상세 (바텀 네비게이션 없음)
      GoRoute(
        path: '/item/:id',
        builder: (context, state) {
          final itemId = state.pathParameters['id']!;
          // 실제로는 itemId로 아이템을 가져와야 하지만, 여기서는 더미 데이터 사용
          final item = ItemModel(
            id: itemId,
            title: '캐논 DSLR 카메라',
            description: '여행용으로 완벽한 DSLR 카메라입니다. 렌즈 포함되어 있으며, 깨끗한 상태로 관리하고 있습니다. 사진 촬영에 관심 있으신 분들께 추천드립니다.',
            price: 15000,
            imageUrl: '',
            category: '카메라',
            location: '강남구 역삼동',
            rating: 4.8,
            reviewCount: 23,
          );
          return ItemDetailScreen(item: item);
        },
      ),
      
      // 알림 (바텀 네비게이션 없음)
      GoRoute(
        path: notifications,
        builder: (context, state) => const NotificationsScreen(),
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