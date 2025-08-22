import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../app/routes/app_routes.dart';
import '../../shared/widgets/cards/cards.dart';
import '../../shared/models/item_model.dart';
import '../../services/supabase_service.dart';
import '../../shared/animations/animations.dart';
import '../../shared/responsive/responsive.dart';
import '../../shared/widgets/optimized_buttons.dart';
import '../../shared/widgets/optimized_search_bar.dart';

// 더미 데이터를 위한 Provider
final popularItemsProvider = FutureProvider<List<ItemModel>>((ref) async {
  // 실제로는 SupabaseService에서 인기 아이템을 가져와야 함
  await Future.delayed(const Duration(seconds: 1)); // 로딩 시뮬레이션
  
  return [
    ItemModel(
      id: '1',
      title: '캐논 EOS R5 카메라',
      description: '전문가용 미러리스 카메라',
      price: 25000,
      imageUrl: '',
      category: '카메라',
      location: '강남구 역삼동',
      rating: 4.9,
      reviewCount: 15,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ItemModel(
      id: '2',
      title: '맥북 프로 M3',
      description: '개발용 노트북 대여',
      price: 35000,
      imageUrl: '',
      category: '노트북',
      location: '서초구 서초동',
      rating: 4.8,
      reviewCount: 22,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    ItemModel(
      id: '3',
      title: '닌텐도 스위치',
      description: '게임기 + 인기 게임 포함',
      price: 12000,
      imageUrl: '',
      category: '게임',
      location: '강남구 신사동',
      rating: 4.7,
      reviewCount: 18,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];
});

final recentItemsProvider = FutureProvider<List<ItemModel>>((ref) async {
  // 실제로는 SupabaseService에서 최근 아이템을 가져와야 함
  await Future.delayed(const Duration(milliseconds: 800)); // 로딩 시뮬레이션
  
  return [
    ItemModel(
      id: '4',
      title: '아이폰 15 Pro',
      description: '최신 스마트폰',
      price: 18000,
      imageUrl: '',
      category: '스마트폰',
      location: '마포구 홍대동',
      rating: 4.9,
      reviewCount: 12,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    ItemModel(
      id: '5',
      title: '다이슨 헤어드라이어',
      description: '고급 헤어드라이어',
      price: 8000,
      imageUrl: '',
      category: '뷰티',
      location: '강남구 청담동',
      rating: 4.6,
      reviewCount: 8,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ItemModel(
      id: '6',
      title: '브루나 텐트',
      description: '캠핑용 4인용 텐트',
      price: 15000,
      imageUrl: '',
      category: '캠핑',
      location: '송파구 잠실동',
      rating: 4.5,
      reviewCount: 10,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];
});

class SimpleHomeScreen extends ConsumerStatefulWidget {
  const SimpleHomeScreen({super.key});

  @override
  ConsumerState<SimpleHomeScreen> createState() => _SimpleHomeScreenState();
}

class _SimpleHomeScreenState extends ConsumerState<SimpleHomeScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _heroController;
  late AnimationController _categoryController;
  late AnimationController _popularController;
  late AnimationController _recentController;
  
  late Animation<double> _heroFadeAnimation;
  late Animation<Offset> _heroSlideAnimation;
  late Animation<double> _categoryFadeAnimation;
  late Animation<Offset> _categorySlideAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // 애니메이션 컨트롤러들 초기화
    _heroController = AnimationController(
      duration: AnimationConfig.normal,
      vsync: this,
    );
    _categoryController = AnimationController(
      duration: AnimationConfig.normal,
      vsync: this,
    );
    _popularController = AnimationController(
      duration: AnimationConfig.normal,
      vsync: this,
    );
    _recentController = AnimationController(
      duration: AnimationConfig.normal,
      vsync: this,
    );
    
    // 애니메이션들 설정
    _heroFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: AnimationConfig.expedaEnter,
    ));
    
    _heroSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: AnimationConfig.expedaEnter,
    ));
    
    _categoryFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _categoryController,
      curve: AnimationConfig.expedaEnter,
    ));
    
    _categorySlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _categoryController,
      curve: AnimationConfig.expedaEnter,
    ));
    
    // 순차적 애니메이션 시작
    _startAnimations();
  }

  void _startAnimations() async {
    await _heroController.forward();
    await Future.delayed(AnimationConfig.staggerDelay);
    await _categoryController.forward();
    await Future.delayed(AnimationConfig.staggerDelay);
    _popularController.forward();
    await Future.delayed(AnimationConfig.staggerDelay);
    _recentController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _heroController.dispose();
    _categoryController.dispose();
    _popularController.dispose();
    _recentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final popularItems = ref.watch(popularItemsProvider);
    final recentItems = ref.watch(recentItemsProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            // Hero Section with Animation
            SliverToBoxAdapter(
              child: PerformanceAwareAnimation(
                child: SlideTransition(
                  position: _heroSlideAnimation,
                  child: FadeTransition(
                    opacity: _heroFadeAnimation,
                    child: _buildHeroSection(context),
                  ),
                ),
              ),
            ),
            
            // Category Grid Section with Animation
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _categorySlideAnimation,
                child: FadeTransition(
                  opacity: _categoryFadeAnimation,
                  child: _buildCategorySection(context),
                ),
              ),
            ),
            
            // Popular Items Section with Animation
            SliverToBoxAdapter(
              child: popularItems.when(
                data: (items) => AnimatedBuilder(
                  animation: _popularController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _popularController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.3),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _popularController,
                          curve: AnimationConfig.expedaEnter,
                        )),
                        child: _buildPopularItemsSection(context, items),
                      ),
                    );
                  },
                ),
                loading: () => AnimatedLoadingState(
                  isLoading: true,
                  child: _buildLoadingSection('인기 아이템'),
                ),
                error: (error, stack) => AnimatedErrorState(
                  hasError: true,
                  errorWidget: _buildErrorSection('인기 아이템을 불러올 수 없습니다'),
                  child: Container(),
                ),
              ),
            ),
            
            // Recent Items Section with Animation
            SliverToBoxAdapter(
              child: recentItems.when(
                data: (items) => AnimatedBuilder(
                  animation: _recentController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _recentController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.3),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _recentController,
                          curve: AnimationConfig.expedaEnter,
                        )),
                        child: _buildRecentItemsSection(context, items),
                      ),
                    );
                  },
                ),
                loading: () => AnimatedLoadingState(
                  isLoading: true,
                  child: _buildLoadingSection('최근 등록 아이템'),
                ),
                error: (error, stack) => AnimatedErrorState(
                  hasError: true,
                  errorWidget: _buildErrorSection('최근 아이템을 불러올 수 없습니다'),
                  child: Container(),
                ),
              ),
            ),
            
            // Bottom padding - 축소
            const SliverToBoxAdapter(
              child: SizedBox(height: 60), // 축소 (100 -> 60)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.22, // 22%로 축소
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16), // 패딩 축소
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with greeting and location
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '안녕하세요! 👋',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.5, // 150% 라인 높이
                      ),
                    ),
                    const SizedBox(height: 2), // 간격 축소
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '강남구 역삼동',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5, // 150% 라인 높이
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AnimatedTouchFeedback(
                onTap: () => context.go(AppRoutes.notifications),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 10), // 간격 더 축소
          
          // Search Bar with proper touch targets
          GestureDetector(
            onTap: () => context.go(AppRoutes.search),
            child: AbsorbPointer(
              child: OptimizedSearchBar(
                hintText: '어떤 아이템을 찾고 계신가요?',
                showFilter: true,
                onFilterTap: () => context.go(AppRoutes.search),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final categories = [
      {'name': '카메라', 'icon': Icons.camera_alt, 'color': Colors.blue},
      {'name': '스포츠', 'icon': Icons.sports_soccer, 'color': Colors.green},
      {'name': '도구', 'icon': Icons.build, 'color': Colors.orange},
      {'name': '주방용품', 'icon': Icons.kitchen, 'color': Colors.red},
      {'name': '완구', 'icon': Icons.toys, 'color': Colors.purple},
      {'name': '악기', 'icon': Icons.music_note, 'color': Colors.indigo},
      {'name': '의류', 'icon': Icons.checkroom, 'color': Colors.pink},
      {'name': '가전제품', 'icon': Icons.electrical_services, 'color': Colors.teal},
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12), // 패딩 축소
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '카테고리',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.5, // 150% 라인 높이
            ),
          ),
          const SizedBox(height: 10), // 간격 축소
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10, // 간격 축소
            crossAxisSpacing: 10, // 간격 축소
            childAspectRatio: 1.0, // 비율 조정
            children: categories.map((category) {
              return AnimatedTouchFeedback(
                onTap: () => context.go('${AppRoutes.search}?category=${category['name']}'),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8), // 패딩 축소
                        decoration: BoxDecoration(
                          color: (category['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8), // 라운드 축소
                        ),
                        child: Icon(
                          category['icon'] as IconData,
                          color: category['color'] as Color,
                          size: 18, // 아이콘 크기 축소
                        ),
                      ),
                      const SizedBox(height: 4), // 간격 축소
                      Text(
                        category['name'] as String,
                        style: const TextStyle(
                          fontSize: 11, // 텍스트 크기 축소
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.5, // 150% 라인 높이
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularItemsSection(BuildContext context, List<ItemModel> items) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 0), // 패딩 축소
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '내 근처 인기 아이템',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.5, // 150% 라인 높이
                ),
              ),
              OptimizedButton(
                label: '전체 보기',
                onPressed: () => context.go(AppRoutes.search),
                type: ButtonType.text,
                icon: Icons.arrow_forward_rounded,
              ),
            ],
          ),
          const SizedBox(height: 10), // 간격 축소
          
          // 인기 아이템 가로 스크롤 리스트
          _buildHorizontalItemsList(context, items),
        ],
      ),
    );
  }

  Widget _buildHorizontalItemsList(BuildContext context, List<ItemModel> items) {
    return SizedBox(
      height: 320, // 높이 축소 (380 -> 320)
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0), // 패딩 제거
        itemCount: items.length,
        itemBuilder: (context, index) {
          return AnimatedListItem(
            index: index,
            delay: const Duration(milliseconds: 100),
            slideFromBottom: false,
            child: Container(
              width: 260, // 너비 축소 (280 -> 260)
              margin: EdgeInsets.only(
                right: index < items.length - 1 ? 12 : 0, // 간격 축소
              ),
              child: AnimatedTouchFeedback(
                onTap: () => context.go(AppRoutes.itemDetail(items[index].id)),
                child: ItemCardFeatured(
                  item: items[index], 
                  showFavorite: true,
                  onFavoriteToggled: (isFavorite) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isFavorite ? '즐겨찾기에 추가했습니다' : '즐겨찾기에서 제거했습니다'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemsGrid(BuildContext context, List<ItemModel> items, int columns) {
    return ResponsivePadding(
      child: ResponsiveGrid(
        minCrossAxisCount: columns,
        maxCrossAxisCount: columns,
        childAspectRatio: 0.75,
        children: items.take(columns * 2).map((item) { // 최대 2행까지
          return AnimatedTouchFeedback(
            onTap: () => context.go(AppRoutes.itemDetail(item.id)),
            child: ItemCardFeatured(
              item: item,
              showFavorite: true,
              onFavoriteToggled: (isFavorite) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFavorite ? '즐겨찾기에 추가했습니다' : '즐겨찾기에서 제거했습니다'),
                    duration: const Duration(seconds: 1),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentItemsSection(BuildContext context, List<ItemModel> items) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '최근 등록된 아이템',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
              OptimizedButton(
                label: '전체 보기',
                onPressed: () => context.go(AppRoutes.search),
                type: ButtonType.text,
                icon: Icons.arrow_forward_rounded,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildRecentItemsList(context, items),
        ],
      ),
    );
  }

  Widget _buildLoadingSection(String title) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5, // 150% 라인 높이
          ),
        ),
      ),
    );
  }

  Widget _buildMobileHeroSection(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroHeader(context),
          SizedBox(height: ResponsiveUtils.getSectionSpacing(context) * 0.6),
          _buildSearchBar(context),
        ],
      ),
    );
  }

  Widget _buildTabletHeroSection(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroHeader(context),
                SizedBox(height: ResponsiveUtils.getSectionSpacing(context) * 0.6),
                _buildSearchBar(context),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 2,
            child: _buildQuickStats(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHeroSection(BuildContext context) {
    return ResponsiveContainer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        padding: EdgeInsets.all(ResponsiveUtils.getPadding(context)),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroHeader(context),
                  SizedBox(height: ResponsiveUtils.getSectionSpacing(context) * 0.6),
                  _buildSearchBar(context),
                ],
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              child: _buildQuickStats(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '안녕하세요! 👋',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getTitleFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '강남구 역삼동',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getCaptionFontSize(context),
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        AnimatedTouchFeedback(
          onTap: () => context.go(AppRoutes.notifications),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return AnimatedTouchFeedback(
      onTap: () => context.go(AppRoutes.search),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '어떤 아이템을 찾고 계신가요?',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getBodyFontSize(context),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            AnimatedTouchFeedback(
              onTap: () => context.go(AppRoutes.search),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘의 통계',
            style: TextStyle(
              fontSize: ResponsiveUtils.getSubTitleFontSize(context),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow('새 아이템', '24', Icons.add_circle_outline),
          const SizedBox(height: 12),
          _buildStatRow('채팅 메시지', '12', Icons.chat_bubble_outline),
          const SizedBox(height: 12),
          _buildStatRow('가입자', '156', Icons.people_outline),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentItemsList(BuildContext context, List<ItemModel> items) {
    return AnimatedListView(
      children: items.map((item) {
        final index = items.indexOf(item);
        return AnimatedTouchFeedback(
          onTap: () => context.go(AppRoutes.itemDetail(item.id)),
          child: Container(
            margin: EdgeInsets.only(
              bottom: index < items.length - 1 ? ResponsiveUtils.getCardSpacing(context) : 0,
            ),
            child: ItemCardCompact(
              item: item,
              showFavorite: true,
              onFavoriteToggled: (isFavorite) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFavorite ? '즐겨찾기에 추가했습니다' : '즐겨찾기에서 제거했습니다'),
                    duration: const Duration(seconds: 1),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
      shrinkWrap: true,
      staggered: true,
      staggerDelay: const Duration(milliseconds: 80),
    );
  }

  Widget _buildRecentItemsGrid(BuildContext context, List<ItemModel> items, int columns) {
    return ResponsiveGrid(
      minCrossAxisCount: columns,
      maxCrossAxisCount: columns,
      childAspectRatio: 0.75,
      children: items.map((item) {
        return AnimatedTouchFeedback(
          onTap: () => context.go(AppRoutes.itemDetail(item.id)),
          child: ItemCardFeatured(
            item: item,
            showFavorite: true,
            onFavoriteToggled: (isFavorite) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorite ? '즐겨찾기에 추가했습니다' : '즐겨찾기에서 제거했습니다'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}