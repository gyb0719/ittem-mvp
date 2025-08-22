import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../core/services/location_service.dart';
import '../../app/routes/app_routes.dart';
import '../../shared/widgets/skeleton/skeleton_widgets.dart';
import '../../shared/models/item_model.dart';
import '../../shared/widgets/item_card.dart';
import '../../services/supabase_service.dart';
import '../../services/performance_service.dart';
import 'widgets/infinite_scroll_list.dart';

// 아이템 모델
class PopularItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String time;
  final Color categoryColor;
  final String categoryLabel;
  final IconData categoryIcon;

  PopularItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.time,
    required this.categoryColor,
    required this.categoryLabel,
    required this.categoryIcon,
  });
}

// 카테고리 모델
class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isPopularItemsLoading = true;
  bool _isCategoriesLoading = true;
  String _currentLocation = '위치 확인 중...';
  final PerformanceService _performanceService = PerformanceService();
  
  // 인기 공유 아이템 데이터
  final List<PopularItem> _popularItems = [
    PopularItem(
      id: '1',
      title: '캐논 DSLR 카메라',
      description: '여행 촬영용',
      category: 'camera',
      time: '오늘, 오후 5:30',
      categoryColor: const Color(0xFFFF6B35),
      categoryLabel: '사진',
      categoryIcon: Icons.camera_alt,
    ),
    PopularItem(
      id: '2',
      title: '캠핑용 텐트 세트',
      description: '4인용 완전 세트',
      category: 'camping',
      time: '오늘, 오후 7:00',
      categoryColor: const Color(0xFF2D3748),
      categoryLabel: '캠핑',
      categoryIcon: Icons.outdoor_grill,
    ),
    PopularItem(
      id: '3',
      title: '아기 유모차',
      description: '신생아용 고급형',
      category: 'baby',
      time: '내일, 오후 6:00',
      categoryColor: const Color(0xFF48BB78),
      categoryLabel: '육아',
      categoryIcon: Icons.child_friendly,
    ),
    PopularItem(
      id: '4',
      title: '게임용 의자',
      description: '인체공학적 설계',
      category: 'furniture',
      time: '오늘, 오후 4:00',
      categoryColor: const Color(0xFF805AD5),
      categoryLabel: '가구',
      categoryIcon: Icons.chair,
    ),
    PopularItem(
      id: '5',
      title: '전자 키보드',
      description: '88건반 디지털 피아노',
      category: 'music',
      time: '내일, 오전 10:00',
      categoryColor: const Color(0xFF3182CE),
      categoryLabel: '악기',
      categoryIcon: Icons.piano,
    ),
  ];
  
  // 카테고리 데이터
  final List<CategoryItem> _categories = [
    CategoryItem(
      id: 'electronics',
      name: '전자제품',
      icon: Icons.phone_android,
      color: const Color(0xFFE6FFFA),
    ),
    CategoryItem(
      id: 'sports',
      name: '스포츠',
      icon: Icons.sports_soccer,
      color: const Color(0xFFE6FFFA),
    ),
    CategoryItem(
      id: 'baby',
      name: '육아용품',
      icon: Icons.child_friendly,
      color: const Color(0xFFF0F9FF),
    ),
    CategoryItem(
      id: 'furniture',
      name: '가구',
      icon: Icons.chair,
      color: const Color(0xFFFFF5F5),
    ),
    CategoryItem(
      id: 'books',
      name: '도서',
      icon: Icons.book,
      color: const Color(0xFFFFF7ED),
    ),
    CategoryItem(
      id: 'fashion',
      name: '패션',
      icon: Icons.checkroom,
      color: const Color(0xFFF3E8FF),
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _performanceService.startMonitoring();
    _getCurrentLocation();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    // 실제 API 호출을 시뮬레이션 
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _isPopularItemsLoading = false;
      });
    }

    // 카테고리는 조금 더 늦게 로딩
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _isCategoriesLoading = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = await LocationService.getCurrentLocation();
      if (location != null && mounted) {
        // 실제로는 역지오코딩을 통해 주소를 가져와야 하지만, 여기서는 좌표로 대체
        setState(() {
          _currentLocation = '현재 위치';
        });
      } else {
        setState(() {
          _currentLocation = '잠실동';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentLocation = '잠실동';
        });
      }
    }
  }
  
  void _onCategoryTap(CategoryItem category) {
    print('카테고리 선택: ${category.name}');
    // 카테고리별 검색 화면으로 이동
    context.push('${AppRoutes.search}?category=${Uri.encodeComponent(category.name)}');
  }

  void _onItemTap(PopularItem item) {
    print('아이템 선택: ${item.title}');
    // 아이템 상세 화면으로 이동
    context.go(AppRoutes.itemDetail(item.id));
  }

  // 실제 아이템 데이터를 불러오는 함수
  Future<List<ItemModel>> _loadItems(int page, int pageSize) async {
    _performanceService.startOperation('load_items_page_$page');
    
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      final items = await supabaseService.getItems(
        limit: pageSize,
        offset: page * pageSize,
      );
      
      _performanceService.endOperation('load_items_page_$page', additionalData: {
        'items_count': items.length,
        'page': page,
      });
      
      return items;
    } catch (e) {
      _performanceService.endOperation('load_items_page_$page', additionalData: {
        'error': e.toString(),
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              _currentLocation,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF1F2937),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF1F2937)),
            onPressed: () {
              context.push(AppRoutes.notifications);
            },
          ),
          // 성능 모니터링 표시 (디버그 모드에서만)
          if (const bool.fromEnvironment('dart.vm.product') == false)
            IconButton(
              icon: Icon(
                Icons.speed,
                color: _performanceService.isPerformanceGood ? Colors.green : Colors.orange,
              ),
              onPressed: () {
                final report = _performanceService.generateReport();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('FPS: ${_performanceService.currentFps.round()}, Memory: ${_performanceService.currentMemoryUsageMB}MB'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 검색창
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  readOnly: true,
                  onTap: () {
                    context.push(AppRoutes.search);
                  },
                  decoration: InputDecoration(
                    hintText: '찾고 있는 물건을 검색해보세요',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[500],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          
          // 인기 공유 아이템 섹션
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '인기 공유 아이템',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 좌우 스크롤 가능한 아이템 목록 또는 스켈레톤
                  SizedBox(
                    height: 120,
                    child: _isPopularItemsLoading
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3, // 스켈레톤은 3개만 보여주기
                            itemBuilder: (context, index) {
                              return Container(
                                width: 300,
                                margin: EdgeInsets.only(
                                  right: index < 2 ? 16 : 0,
                                ),
                                child: _buildPopularItemSkeleton(),
                              );
                            },
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _popularItems.length,
                            itemBuilder: (context, index) {
                              final item = _popularItems[index];
                              return Container(
                                width: 300,
                                margin: EdgeInsets.only(
                                  right: index < _popularItems.length - 1 ? 16 : 0,
                                ),
                                child: _buildPopularItemCard(item),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          
          // 카테고리 섹션
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '카테고리',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 카테고리 그리드 또는 스켈레톤
                  _isCategoriesLoading
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: 6, // 스켈레톤은 6개 표시
                          itemBuilder: (context, index) {
                            return _buildCategorySkeleton();
                          },
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return _buildCategoryCard(category);
                          },
                        ),
                ],
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          
          // 전체 아이템 목록 섹션 (무한 스크롤)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: const Text(
                '전체 아이템',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ),
          
          // 무한 스크롤 아이템 리스트
          SliverFillRemaining(
            child: Container(
              color: Colors.white,
              child: InfiniteScrollList(
                onLoadMore: _loadItems,
                scrollableId: 'home_items',
                config: const PaginationConfig(
                  pageSize: 20,
                  preloadThreshold: 0.8,
                  maxPreloadPages: 2,
                ),
                itemBuilder: (item, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ItemCard(
                      item: item,
                      onTap: () => context.go(AppRoutes.itemDetail(item.id)),
                    ),
                  );
                },
                padding: const EdgeInsets.only(
                  bottom: 100, // 하단 네비게이션 여백
                  top: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 인기 아이템 카드 위젯
  Widget _buildPopularItemCard(PopularItem item) {
    return GestureDetector(
      onTap: () => _onItemTap(item),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            // 카테고리 아이콘
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: item.categoryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.categoryIcon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            
            // 아이템 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.categoryLabel,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 인기 아이템 스켈레톤
  Widget _buildPopularItemSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // 카테고리 아이콘 스켈레톤
          SkeletonBox(
            width: 60,
            height: 60,
            borderRadius: 12,
          ),
          const SizedBox(width: 12),
          
          // 아이템 정보 스켈레톤
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SkeletonBox(
                      width: 40,
                      height: 16,
                      borderRadius: 4,
                    ),
                    const Spacer(),
                    SkeletonCircle.icon(size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                SkeletonText.title(width: 180),
                const SizedBox(height: 4),
                SkeletonText.body(width: 120),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SkeletonCircle.icon(size: 12),
                    const SizedBox(width: 4),
                    SkeletonText.caption(width: 100),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 카테고리 스켈레톤
  Widget _buildCategorySkeleton() {
    return Container(
      decoration: BoxDecoration(
        color: SkeletonColors.getBaseColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonBox(
            width: 48,
            height: 48,
            borderRadius: 12,
          ),
          const SizedBox(height: 8),
          SkeletonText.body(width: 60),
        ],
      ),
    );
  }

  // 카테고리 카드 위젯
  Widget _buildCategoryCard(CategoryItem category) {
    return GestureDetector(
      onTap: () => _onCategoryTap(category),
      child: Container(
        decoration: BoxDecoration(
          color: category.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category.icon,
                color: const Color(0xFF1F2937),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _performanceService.stopMonitoring();
    super.dispose();
  }
}