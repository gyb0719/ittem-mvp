import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import 'routes/app_routes.dart';

class IttemApp extends ConsumerWidget {
  const IttemApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Ittem - 지역 기반 물건 대여',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  final Widget child;
  
  const MainNavigationWrapper({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.items);
        break;
      case 2:
        context.go(AppRoutes.chat);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = ModalRoute.of(context)?.settings.name ?? AppRoutes.home;
    switch (state) {
      case AppRoutes.home:
        _selectedIndex = 0;
        break;
      case AppRoutes.items:
        _selectedIndex = 1;
        break;
      case AppRoutes.chat:
        _selectedIndex = 2;
        break;
      case AppRoutes.profile:
        _selectedIndex = 3;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: '대여목록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}