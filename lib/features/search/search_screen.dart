import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/models/item_model.dart';
import '../../shared/widgets/teal_components.dart';
import '../../shared/widgets/item_card.dart';
import '../../services/supabase_service.dart';
import '../../services/search_service.dart';
import '../../services/performance_service.dart';
import '../../services/image_cache_service.dart';
import '../../app/routes/app_routes.dart';
import '../../theme/colors.dart';
import '../../shared/widgets/skeleton/advanced_skeleton_widgets.dart';
import '../home/widgets/infinite_scroll_list.dart';
import 'widgets/search_filter_sheet.dart';
import 'widgets/search_suggestions.dart';
import 'widgets/search_no_results.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  final String? initialCategory;
  
  const SearchScreen({
    super.key,
    this.initialQuery,
    this.initialCategory,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  final PerformanceService _performanceService = PerformanceService();
  
  List<ItemModel> _items = [];
  List<String> _recentSearches = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  bool _showSuggestions = false;
  String _lastQuery = '';
  
  // 필터 상태 - SearchFilters 객체로 관리
  SearchFilters _filters = SearchFilters.defaultFilters();

  final List<Map<String, String>> _sortOptions = [
    {'key': 'latest', 'label': '최신순'},
    {'key': 'price_low', 'label': '가격 낮은순'},
    {'key': 'price_high', 'label': '가격 높은순'},
    {'key': 'rating', 'label': '평점 높은순'},
    {'key': 'distance', 'label': '거리순'},
  ];

  // 빠른 필터 옵션들
  final List<Map<String, dynamic>> _quickFilters = [
    {'label': '1만원 이하', 'type': 'price', 'value': {'min': 0, 'max': 10000}},
    {'label': '3km 이내', 'type': 'distance', 'value': 3.0},
    {'label': '오늘 등록', 'type': 'date', 'value': 'today'},
    {'label': '평점 4.5+', 'type': 'rating', 'value': 4.5},
  ];

  @override
  void initState() {
    super.initState();
    _performanceService.startMonitoring();
    
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _lastQuery = widget.initialQuery!;
    }
    if (widget.initialCategory != null) {
      _filters = _filters.copyWith(category: widget.initialCategory!);
    }
    _scrollController.addListener(_onScroll);
    _searchFocusNode.addListener(_onFocusChanged);
    _loadRecentSearches();
    _loadSavedFilters();
    if (widget.initialQuery != null || widget.initialCategory != null) {
      _performSearch();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _performanceService.stopMonitoring();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadMoreItems();
      }
    }
  }

  void _loadRecentSearches() async {
    final searchService = ref.read(searchServiceProvider);
    final history = await searchService.getSearchHistory();
    if (mounted) {
      setState(() {
        _recentSearches = history;
      });
    }
  }

  void _loadSavedFilters() async {
    final searchService = ref.read(searchServiceProvider);
    final savedFilters = await searchService.getSavedFilters();
    if (mounted) {
      setState(() {
        _filters = savedFilters;
      });
    }
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = _searchFocusNode.hasFocus;
    });
  }

  void _saveRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    final searchService = ref.read(searchServiceProvider);
    await searchService.addSearchHistory(query);
    _loadRecentSearches();
  }

  void _removeRecentSearch(String query) async {
    final searchService = ref.read(searchServiceProvider);
    await searchService.removeSearchHistory(query);
    _loadRecentSearches();
  }

  void _clearSearchHistory() async {
    final searchService = ref.read(searchServiceProvider);
    await searchService.clearSearchHistory();
    _loadRecentSearches();
  }

  void _saveFilters() async {
    final searchService = ref.read(searchServiceProvider);
    await searchService.saveFilters(_filters);
  }

  Future<void> _performSearch() async {
    _performanceService.startOperation('perform_search');
    
    setState(() {
      _isLoading = true;
      _currentPage = 0;
      _items.clear();
      _hasMore = true;
    });

    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _saveRecentSearch(query);
    }

    await _loadItems();
    
    _performanceService.endOperation('perform_search');
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading || !_hasMore) return;
    
    _performanceService.startOperation('load_more_items');
    
    setState(() {
      _isLoading = true;
      _currentPage++;
    });

    await _loadItems();
    
    _performanceService.endOperation('load_more_items');
  }

  Future<void> _loadItems() async {
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      final query = _searchController.text.trim();
      
      // 성능 최적화: 같은 쿠리를 연속으로 검색하지 않도록 방지
      if (query == _lastQuery && _currentPage == 0) {
        await Future.delayed(const Duration(milliseconds: 100)); // 디바운싱
      }
      _lastQuery = query;
      
      final newItems = await supabaseService.getItems(
        category: _filters.category == '전체' ? null : _filters.category,
        location: _filters.location == '전체' ? null : _filters.location,
        limit: 20,
        offset: _currentPage * 20,
      );

      // 로컬 필터링 적용 (서버에서 처리하는 것이 이상적)
      final filteredItems = newItems.where((item) {
        if (_filters.onlyAvailable && !item.isAvailable) return false;
        if (item.price < _filters.minPrice || item.price > _filters.maxPrice) return false;
        
        if (query.isNotEmpty) {
          return item.title.toLowerCase().contains(query.toLowerCase()) ||
                 item.description.toLowerCase().contains(query.toLowerCase()) ||
                 item.category.toLowerCase().contains(query.toLowerCase());
        }
        
        return true;
      }).toList();

      // 정렬 적용
      _sortItems(filteredItems);
      
      // 이미지 프리로드 (Smart preloading)
      if (filteredItems.isNotEmpty && _currentPage == 0) {
        final imageUrls = filteredItems
            .take(5)
            .where((item) => item.imageUrl.isNotEmpty)
            .map((item) => item.imageUrl)
            .toList();
        
        if (imageUrls.isNotEmpty) {
          ImageCacheService.preloadImages(imageUrls, priority: true);
        }
      }
      
      setState(() {
        if (_currentPage == 0) {
          _items = filteredItems;
        } else {
          _items.addAll(filteredItems);
        }
        _hasMore = newItems.length == 20;
        _isLoading = false;
      });
      
      _performanceService.endOperation('search_load_page_$_currentPage', additionalData: {
        'items_found': filteredItems.length,
        'query': query,
        'has_filters': _filters.hasActiveFilters,
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      _performanceService.endOperation('search_load_page_$_currentPage', additionalData: {
        'error': e.toString(),
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('검색 중 오류가 발생했습니다: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
  
  // 최적화된 검색 아이템 로드 함수 (나중에 사용할 수 있도록 보존)
  Future<List<ItemModel>> _loadSearchItems(int page, int pageSize) async {
    _performanceService.startOperation('search_load_page_$page');
    
    try {
      final supabaseService = ref.read(supabaseServiceProvider);
      final query = _searchController.text.trim();
      
      // 성능 최적화: 같은 쿠리를 연속으로 검색하지 않도록 방지
      if (query == _lastQuery && page == 0) {
        await Future.delayed(const Duration(milliseconds: 100)); // 디바운싱
      }
      _lastQuery = query;
      
      final newItems = await supabaseService.getItems(
        category: _filters.category == '전체' ? null : _filters.category,
        location: _filters.location == '전체' ? null : _filters.location,
        limit: pageSize,
        offset: page * pageSize,
      );

      // 로컬 필터링 적용 (서버에서 처리하는 것이 이상적)
      final filteredItems = newItems.where((item) {
        if (_filters.onlyAvailable && !item.isAvailable) return false;
        if (item.price < _filters.minPrice || item.price > _filters.maxPrice) return false;
        
        if (query.isNotEmpty) {
          return item.title.toLowerCase().contains(query.toLowerCase()) ||
                 item.description.toLowerCase().contains(query.toLowerCase()) ||
                 item.category.toLowerCase().contains(query.toLowerCase());
        }
        
        return true;
      }).toList();

      // 정렬 적용
      _sortItems(filteredItems);
      
      // 이미지 프리로드 (Smart preloading)
      if (filteredItems.isNotEmpty && page == 0) {
        final imageUrls = filteredItems
            .take(5)
            .where((item) => item.imageUrl.isNotEmpty)
            .map((item) => item.imageUrl)
            .toList();
        
        if (imageUrls.isNotEmpty) {
          ImageCacheService.preloadImages(imageUrls, priority: true);
        }
      }
      
      _performanceService.endOperation('search_load_items_future', additionalData: {
        'items_found': filteredItems.length,
        'query': query,
        'has_filters': _filters.hasActiveFilters,
      });
      
      return filteredItems;
      
    } catch (e) {
      _performanceService.endOperation('search_load_items_future', additionalData: {
        'error': e.toString(),
      });
      rethrow;
    }
  }

  void _sortItems(List<ItemModel> items) {
    switch (_filters.sortBy) {
      case 'latest':
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'price_low':
        items.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        items.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        items.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'distance':
        // TODO: Implement distance sorting when location is available
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildSearchAppBar(),
      body: PerformanceWidget(
        operationName: 'search_screen_build',
        child: Column(
          children: [
            // 빠른 필터와 정렬
            if (!_showSuggestions && _searchController.text.isNotEmpty)
              _buildQuickFiltersAndSort(),
            
            // 활성 필터 칩들
            if (_filters.hasActiveFilters && !_showSuggestions) 
              _buildActiveFilters(),
            
            // 메인 컨텐츠
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _searchFocusNode.hasFocus ? AppColors.primary : AppColors.separator,
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: '찾고 있는 물건을 검색해보세요',
            hintStyle: TextStyle(color: AppColors.textTertiary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: 20,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {
                        _showSuggestions = true;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  )
                : null,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              _searchFocusNode.unfocus();
              _performSearch();
            }
          },
          onChanged: (query) {
            setState(() {
              // Real-time suggestion update could be added here
            });
          },
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.tune,
                  color: _filters.hasActiveFilters ? AppColors.primary : AppColors.textSecondary,
                ),
                onPressed: _showFilterBottomSheet,
              ),
              if (_filters.hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.separator,
        ),
      ),
    );
  }

  Widget _buildQuickFiltersAndSort() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 빠른 필터들
          Expanded(
            child: SizedBox(
              height: 32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _quickFilters.length,
                itemBuilder: (context, index) {
                  final filter = _quickFilters[index];
                  final isActive = _isQuickFilterActive(filter);
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: TealChip(
                      label: filter['label'],
                      size: TealChipSize.small,
                      isSelected: isActive,
                      onPressed: () => _toggleQuickFilter(filter),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 정렬 버튼
          GestureDetector(
            onTap: _showSortBottomSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.separator),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sort,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getSortLabel(_filters.sortBy),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    final activeFilters = <Widget>[];
    
    if (_filters.category != '전체') {
      activeFilters.add(
        TealChip(
          label: _filters.category,
          size: TealChipSize.small,
          onDeleted: () {
            setState(() {
              _filters = _filters.copyWith(category: '전체');
            });
            _saveFilters();
            _performSearch();
          },
        ),
      );
    }
    
    if (_filters.location != '전체') {
      activeFilters.add(
        TealChip(
          label: _filters.location,
          size: TealChipSize.small,
          icon: Icons.location_on,
          onDeleted: () {
            setState(() {
              _filters = _filters.copyWith(location: '전체');
            });
            _saveFilters();
            _performSearch();
          },
        ),
      );
    }
    
    if (_filters.minPrice > 0 || _filters.maxPrice < 100000) {
      activeFilters.add(
        TealChip(
          label: '${_formatPrice(_filters.minPrice.toInt())} - ${_formatPrice(_filters.maxPrice.toInt())}원',
          size: TealChipSize.small,
          icon: Icons.payments,
          onDeleted: () {
            setState(() {
              _filters = _filters.copyWith(minPrice: 0, maxPrice: 100000);
            });
            _saveFilters();
            _performSearch();
          },
        ),
      );
    }
    
    if (_filters.maxDistance < 10.0) {
      activeFilters.add(
        TealChip(
          label: '${_filters.maxDistance.toInt()}km 이내',
          size: TealChipSize.small,
          icon: Icons.near_me,
          onDeleted: () {
            setState(() {
              _filters = _filters.copyWith(maxDistance: 10.0);
            });
            _saveFilters();
            _performSearch();
          },
        ),
      );
    }
    
    if (activeFilters.isEmpty) return const SizedBox.shrink();
    
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: activeFilters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) => activeFilters[index],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _clearAllFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                '전체 삭제',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_showSuggestions || _searchController.text.isEmpty) {
      return SearchSuggestions(
        query: _searchController.text,
        searchHistory: _recentSearches,
        onSuggestionTap: (query) {
          _searchController.text = query;
          _searchFocusNode.unfocus();
          _performSearch();
        },
        onHistoryRemove: _removeRecentSearch,
        onClearHistory: _clearSearchHistory,
      );
    }
    
    if (_isLoading && _items.isEmpty) {
      return SmartSkeletonWidget(
        isLoading: true,
        child: Container(),
        customSkeleton: GridSkeletonLoader(
          itemCount: SkeletonUtils.getOptimalSkeletonCount(6),
          crossAxisCount: 2,
        ),
      );
    }
    
    if (_items.isEmpty && !_isLoading) {
      return SearchNoResults(
        query: _searchController.text,
        filters: _filters,
        onSuggestionTap: (query) {
          _searchController.text = query;
          _performSearch();
        },
        onClearFilters: _clearAllFilters,
        onExpandSearch: _expandSearchScope,
      );
    }
    
    return _buildOptimizedSearchResults();
  }

  Widget _buildOptimizedSearchResults() {
    return Column(
      children: [
        // 결과 수와 정보
        if (_items.isNotEmpty) _buildResultsHeader(),
        
        // 최적화된 그리드 뷰
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _items.length + (_isLoading ? 2 : 0),
            itemBuilder: (context, index) {
              if (index >= _items.length) {
                return ItemCardSkeleton(
                  showPrice: true,
                  showLocation: true,
                  showLikeButton: true,
                );
              }
              
              final item = _items[index];
              return PerformanceWidget(
                operationName: 'search_item_$index',
                child: ItemCard(
                  item: item,
                  onTap: () => context.go(AppRoutes.itemDetail(item.id)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildResultsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.separator)),
      ),
      child: Row(
        children: [
          Text(
            '총 ${_items.length}개의 물건',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (_searchController.text.isNotEmpty) ...[
            Text(
              ' · "${_searchController.text}"',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const Spacer(),
          if (_filters.hasActiveFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.tealPale,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '필터 ${_filters.activeFilterCount}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchFilterSheet(
        initialFilters: _filters,
        onFiltersChanged: (newFilters) {
          setState(() {
            _filters = newFilters;
          });
          _saveFilters();
          _performSearch();
        },
      ),
    );
  }
  
  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '정렬 순서',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ..._sortOptions.map((option) {
              final isSelected = _filters.sortBy == option['key'];
              return ListTile(
                title: Text(
                  option['label']!,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() {
                    _filters = _filters.copyWith(sortBy: option['key']);
                  });
                  _saveFilters();
                  _performSearch();
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  bool _isQuickFilterActive(Map<String, dynamic> filter) {
    switch (filter['type']) {
      case 'price':
        return _filters.minPrice == filter['value']['min'] &&
               _filters.maxPrice == filter['value']['max'];
      case 'distance':
        return _filters.maxDistance == filter['value'];
      case 'date':
        // TODO: Implement date filtering
        return false;
      case 'rating':
        // TODO: Implement rating filtering
        return false;
      default:
        return false;
    }
  }
  
  void _toggleQuickFilter(Map<String, dynamic> filter) {
    setState(() {
      switch (filter['type']) {
        case 'price':
          if (_isQuickFilterActive(filter)) {
            _filters = _filters.copyWith(minPrice: 0, maxPrice: 100000);
          } else {
            _filters = _filters.copyWith(
              minPrice: filter['value']['min'].toDouble(),
              maxPrice: filter['value']['max'].toDouble(),
            );
          }
          break;
        case 'distance':
          if (_isQuickFilterActive(filter)) {
            _filters = _filters.copyWith(maxDistance: 10.0);
          } else {
            _filters = _filters.copyWith(maxDistance: filter['value']);
          }
          break;
      }
    });
    _saveFilters();
    _performSearch();
  }
  
  String _getSortLabel(String sortKey) {
    return _sortOptions.firstWhere(
      (option) => option['key'] == sortKey,
      orElse: () => {'label': '최신순'},
    )['label']!;
  }
  
  void _clearAllFilters() {
    setState(() {
      _filters = SearchFilters.defaultFilters();
    });
    _saveFilters();
    _performSearch();
  }
  
  void _expandSearchScope() {
    _performanceService.startOperation('expand_search_scope');
    
    setState(() {
      _filters = _filters.copyWith(
        location: '전체',
        maxDistance: 50.0,
        minPrice: 0,
        maxPrice: 1000000,
      );
    });
    _saveFilters();
    _performSearch();
    
    _performanceService.endOperation('expand_search_scope');
  }

  String _formatPrice(int price) {
    if (price >= 10000) {
      final man = price ~/ 10000;
      final remainder = price % 10000;
      if (remainder == 0) {
        return '$man만';
      } else {
        return '$man만 ${_formatThousands(remainder)}';
      }
    }
    return _formatThousands(price);
  }

  String _formatThousands(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}