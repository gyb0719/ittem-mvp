import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme_service.dart';
import '../shared/animations/animations.dart';
import '../shared/responsive/adaptive_scaffold.dart';
import 'routes/app_routes.dart';

class IttemApp extends ConsumerWidget {
  const IttemApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    
    ThemeMode materialThemeMode;
    switch (themeMode) {
      case AppThemeMode.light:
        materialThemeMode = ThemeMode.light;
        break;
      case AppThemeMode.dark:
        materialThemeMode = ThemeMode.dark;
        break;
      case AppThemeMode.system:
        materialThemeMode = ThemeMode.system;
        break;
    }

    return MaterialApp.router(
      title: 'Ittem - 우리 동네 물건 공유',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: materialThemeMode,
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
    );
  }
}

class MainNavigationWrapper extends StatelessWidget {
  final Widget child;
  
  const MainNavigationWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // 현재 라우트 가져오기
    final currentRoute = GoRouterState.of(context).matchedLocation;
    
    // 홈 화면인지 확인
    final isHome = currentRoute == '/home';
    
    return PopScope(
      canPop: !isHome, // 홈 화면이 아닐 때만 뒤로 가기 가능
      onPopInvoked: (didPop) {
        if (!didPop && !isHome) {
          // 홈이 아닌 화면에서 홈으로 이동
          context.go('/home');
        }
      },
      child: AdaptiveScaffold(
        body: child,
        currentRoute: currentRoute,
        destinations: DefaultDestinations.main,
      ),
    );
  }
}

