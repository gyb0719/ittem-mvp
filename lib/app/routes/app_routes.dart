import 'package:go_router/go_router.dart';
import '../../features/home/home_screen_simple.dart';
import '../../features/news/news_screen.dart';
import '../../features/items/add_item_screen.dart';
import '../../features/items/item_detail_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/auth/signup_screen.dart';
import '../../features/auth/welcome_screen.dart';
import '../../features/auth/phone_login_screen.dart';
import '../../features/auth/verification_screen.dart';
import '../../features/auth/profile_setup_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/demo/teal_components_demo.dart';
import '../../features/demo/skeleton_demo_screen.dart';
import '../../features/demo/korean_animations_demo.dart';
import '../../features/items/edit_item_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/search/search_filter_screen.dart';
import '../../shared/models/item_model.dart';
import '../../shared/animations/animations.dart';
import '../app.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String news = '/news';
  static const String items = '/items';
  static const String addItem = '/add-item';
  static String itemDetail(String id) => '/item/$id';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String map = '/map';
  static const String notifications = '/notifications';
  static const String signup = '/signup';
  static const String phoneLogin = '/phone-login';
  static const String verification = '/verification';
  static const String profileSetup = '/profile-setup';
  static const String search = '/search';
  static const String searchFilter = '/search/filter';
  static String editItem(String id) => '/item/$id/edit';
  static const String componentsDemo = '/components-demo';
  static const String skeletonDemo = '/skeleton-demo';
  static const String animationsDemo = '/animations-demo';
  
  static final GoRouter router = GoRouter(
    // 인증 상태에 따른 초기 라우팅 - 빠른 앱 시작을 위해 홈으로 직접 이동
    initialLocation: home,
    routes: [
      // 온보딩 스플래시 화면 (필요시에만 표시 - 바텀 네비게이션 없음)
      GoRoute(
        path: splash,
        pageBuilder: (context, state) => PageTransitionFactory.fade(
          const OptimizedSplashScreen(),
          name: state.name,
        ),
      ),
      
      // 웰컴 화면 (바텀 네비게이션 없음)
      GoRoute(
        path: welcome,
        pageBuilder: (context, state) => PageTransitionFactory.slide(
          const WelcomeScreen(),
          name: state.name,
        ),
      ),
      
      // 인증 관련 라우트 (바텀 네비게이션 없음)
      GoRoute(
        path: signup,
        pageBuilder: (context, state) => PageTransitionFactory.slide(
          const SignUpScreen(),
          name: state.name,
        ),
      ),
      GoRoute(
        path: phoneLogin,
        pageBuilder: (context, state) => PageTransitionFactory.slide(
          const PhoneLoginScreen(),
          name: state.name,
        ),
      ),
      GoRoute(
        path: verification,
        pageBuilder: (context, state) {
          final email = state.uri.queryParameters['email'];
          final phone = state.uri.queryParameters['phone'];
          return PageTransitionFactory.slide(
            VerificationScreen(email: email, phone: phone),
            name: state.name,
          );
        },
      ),
      GoRoute(
        path: profileSetup,
        pageBuilder: (context, state) {
          final email = state.uri.queryParameters['email'];
          final phone = state.uri.queryParameters['phone'];
          return PageTransitionFactory.slide(
            ProfileSetupScreen(email: email, phone: phone),
            name: state.name,
          );
        },
      ),
      
      // 아이템 등록 (바텀 네비게이션 없음)
      GoRoute(
        path: addItem,
        pageBuilder: (context, state) => PageTransitionFactory.modal(
          const AddItemScreen(),
          name: state.name,
        ),
      ),
      
      // 아이템 상세 (바텀 네비게이션 없음)
      GoRoute(
        path: '/item/:id',
        pageBuilder: (context, state) {
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
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          );
          return PageTransitionFactory.scale(
            ItemDetailScreen(item: item),
            name: state.name,
          );
        },
      ),
      
      // 알림 (바텀 네비게이션 없음)
      GoRoute(
        path: notifications,
        pageBuilder: (context, state) => PageTransitionFactory.slide(
          const NotificationsScreen(),
          name: state.name,
        ),
      ),
      
      // 검색 (바텀 네비게이션 없음)
      GoRoute(
        path: search,
        pageBuilder: (context, state) {
          final query = state.uri.queryParameters['q'];
          final category = state.uri.queryParameters['category'];
          return PageTransitionFactory.fade(
            SearchScreen(
              initialQuery: query,
              initialCategory: category,
            ),
            name: state.name,
          );
        },
      ),

      // 검색 필터 (바텀 네비게이션 없음)
      GoRoute(
        path: searchFilter,
        pageBuilder: (context, state) {
          final query = state.uri.queryParameters['q'];
          final category = state.uri.queryParameters['category'];
          return PageTransitionFactory.slide(
            SearchFilterScreen(
              initialQuery: query,
              initialCategory: category,
            ),
            name: state.name,
          );
        },
      ),
      
      // 아이템 수정 (바텀 네비게이션 없음)
      GoRoute(
        path: '/item/:id/edit',
        pageBuilder: (context, state) {
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
            createdAt: DateTime.now().subtract(const Duration(days: 5)),
          );
          return PageTransitionFactory.modal(
            EditItemScreen(item: item),
            name: state.name,
          );
        },
      ),
      
      // 컴포넌트 데모 (바텀 네비게이션 없음)
      GoRoute(
        path: componentsDemo,
        pageBuilder: (context, state) => PageTransitionFactory.slide(
          const TealComponentsDemo(),
          name: state.name,
        ),
      ),
      
      // Skeleton 데모 (바텀 네비게이션 없음)
      GoRoute(
        path: skeletonDemo,
        pageBuilder: (context, state) => PageTransitionFactory.slide(
          const SkeletonDemoScreen(),
          name: state.name,
        ),
      ),
      
      // Korean Animations 데모 (바텀 네비게이션 없음)
      GoRoute(
        path: animationsDemo,
        pageBuilder: (context, state) => PageTransitionFactory.slide(
          const KoreanAnimationsDemo(),
          name: state.name,
        ),
      ),
      
      // 메인 앱 라우트 (바텀 네비게이션 포함)
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: home,
            pageBuilder: (context, state) => PageTransitionFactory.tab(
              const SimpleHomeScreen(),
              name: state.name,
            ),
          ),
          GoRoute(
            path: news,
            pageBuilder: (context, state) => PageTransitionFactory.tab(
              const NewsScreen(),
              name: state.name,
            ),
          ),
          GoRoute(
            path: chat,
            pageBuilder: (context, state) => PageTransitionFactory.tab(
              const ChatScreen(),
              name: state.name,
            ),
          ),
          GoRoute(
            path: profile,
            pageBuilder: (context, state) => PageTransitionFactory.tab(
              const ProfileScreen(),
              name: state.name,
            ),
          ),
          GoRoute(
            path: map,
            pageBuilder: (context, state) => PageTransitionFactory.tab(
              const MapScreen(),
              name: state.name,
            ),
          ),
        ],
      ),
    ],
  );
}