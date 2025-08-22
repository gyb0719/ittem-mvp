import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'responsive_utils.dart';
import '../../app/routes/app_routes.dart';
import '../../theme/colors.dart';
import '../animations/animations.dart';

/// 적응형 스캐폴드
/// 화면 크기에 따라 하단 네비게이션, 네비게이션 레일, 또는 사이드바를 자동 선택
class AdaptiveScaffold extends StatefulWidget {
  final Widget body;
  final String currentRoute;
  final List<AdaptiveDestination> destinations;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    required this.currentRoute,
    required this.destinations,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> 
    with TickerProviderStateMixin {
  late AnimationController _navController;
  late Animation<double> _navFadeAnimation;

  @override
  void initState() {
    super.initState();
    _navController = AnimationController(
      duration: AnimationConfig.fast,
      vsync: this,
    );

    _navFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _navController,
      curve: AnimationConfig.expedaEnter,
    ));

    // 네비게이션 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _navController.forward();
      }
    });
  }

  @override
  void dispose() {
    _navController.dispose();
    super.dispose();
  }

  int get _selectedIndex {
    for (int i = 0; i < widget.destinations.length; i++) {
      if (widget.destinations[i].route == widget.currentRoute) {
        return i;
      }
    }
    return 0;
  }

  void _onDestinationSelected(int index) {
    if (index != _selectedIndex) {
      final destination = widget.destinations[index];
      context.go(destination.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationType = ResponsiveUtils.getNavigationType(context);

    return FPSMonitor(
      child: PerformanceAwareAnimation(
        child: _buildScaffold(context, navigationType),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, NavigationType navigationType) {
    switch (navigationType) {
      case NavigationType.bottomBar:
        return _buildBottomNavigationScaffold();
        
      case NavigationType.rail:
        return _buildNavigationRailScaffold();
        
      case NavigationType.sidebar:
        return _buildSidebarScaffold();
    }
  }

  Widget _buildBottomNavigationScaffold() {
    return Scaffold(
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      bottomNavigationBar: FadeTransition(
        opacity: _navFadeAnimation,
        child: _AdaptiveBottomNavigationBar(
          destinations: widget.destinations,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
        ),
      ),
    );
  }

  Widget _buildNavigationRailScaffold() {
    return Scaffold(
      body: Row(
        children: [
          FadeTransition(
            opacity: _navFadeAnimation,
            child: _AdaptiveNavigationRail(
              destinations: widget.destinations,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.body),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
    );
  }

  Widget _buildSidebarScaffold() {
    return Scaffold(
      body: Row(
        children: [
          FadeTransition(
            opacity: _navFadeAnimation,
            child: _AdaptiveSidebar(
              destinations: widget.destinations,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.body),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
    );
  }
}

/// 하단 네비게이션 바
class _AdaptiveBottomNavigationBar extends StatefulWidget {
  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const _AdaptiveBottomNavigationBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<_AdaptiveBottomNavigationBar> createState() => _AdaptiveBottomNavigationBarState();
}

class _AdaptiveBottomNavigationBarState extends State<_AdaptiveBottomNavigationBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.destinations.length,
      (index) => AnimationController(
        duration: AnimationConfig.buttonPress,
        vsync: this,
      ),
    );

    _scaleAnimations = _controllers
        .map((controller) => Tween<double>(begin: 1.0, end: 1.2).animate(
              CurvedAnimation(
                parent: controller,
                curve: AnimationConfig.bounceCurve,
              ),
            ))
        .toList();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(_AdaptiveBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _controllers[widget.selectedIndex].forward().then((_) {
        _controllers[widget.selectedIndex].reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.selectedIndex,
        onTap: widget.onDestinationSelected,
        elevation: 0,
        items: widget.destinations.map((destination) {
          final index = widget.destinations.indexOf(destination);
          return _buildAnimatedNavItem(
            index,
            destination.icon,
            destination.selectedIcon ?? destination.icon,
            destination.label,
          );
        }).toList(),
      ),
    );
  }

  BottomNavigationBarItem _buildAnimatedNavItem(
    int index,
    IconData icon,
    IconData selectedIcon,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: AnimatedBuilder(
        animation: _scaleAnimations[index],
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimations[index].value,
            child: Icon(
              widget.selectedIndex == index ? selectedIcon : icon,
            ),
          );
        },
      ),
      label: label,
    );
  }
}

/// 네비게이션 레일 (태블릿)
class _AdaptiveNavigationRail extends StatelessWidget {
  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const _AdaptiveNavigationRail({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: Colors.transparent,
        destinations: destinations.map((destination) {
          return NavigationRailDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon ?? destination.icon),
            label: Text(
              destination.label,
              style: const TextStyle(fontSize: 10),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 사이드바 (데스크톱)
class _AdaptiveSidebar extends StatelessWidget {
  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const _AdaptiveSidebar({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Ittem',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // 네비게이션 아이템들
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                final isSelected = index == selectedIndex;
                
                return AnimatedTouchFeedback(
                  onTap: () => onDestinationSelected(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: ListTile(
                      leading: Icon(
                        isSelected 
                            ? (destination.selectedIcon ?? destination.icon)
                            : destination.icon,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                      title: Text(
                        destination.label,
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedTileColor: AppColors.primary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 하단 사용자 정보 (옵션)
          if (ResponsiveUtils.isWide(context))
            Container(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '사용자',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '강남구 역삼동',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 네비게이션 목적지 정의
class AdaptiveDestination {
  final String route;
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final String? tooltip;

  const AdaptiveDestination({
    required this.route,
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.tooltip,
  });
}

/// 기본 네비게이션 목적지들
class DefaultDestinations {
  static const List<AdaptiveDestination> main = [
    AdaptiveDestination(
      route: AppRoutes.home,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: '홈',
    ),
    AdaptiveDestination(
      route: AppRoutes.news,
      icon: Icons.newspaper_outlined,
      selectedIcon: Icons.newspaper,
      label: '동네소식',
    ),
    AdaptiveDestination(
      route: AppRoutes.addItem,
      icon: Icons.add_circle_outline,
      selectedIcon: Icons.add_circle,
      label: '상품 등록',
    ),
    AdaptiveDestination(
      route: AppRoutes.chat,
      icon: Icons.chat_bubble_outline,
      selectedIcon: Icons.chat_bubble,
      label: '채팅',
    ),
    AdaptiveDestination(
      route: AppRoutes.profile,
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: '마이페이지',
    ),
  ];
}