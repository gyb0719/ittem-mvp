import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/item_model.dart';
import '../../../services/performance_service.dart';
import '../../../services/image_cache_service.dart';
import '../../../shared/widgets/item_card.dart';
import '../../../theme/colors.dart';

// 스마트 페이지네이션을 위한 구성
class PaginationConfig {
  final int pageSize;
  final double preloadThreshold; // 얼마나 미리 로드할지 (0.8 = 80% 스크롤 시)
  final int maxPreloadPages; // 최대 미리 로드할 페이지 수
  final Duration debounceDelay; // 스크롤 디바운싱
  
  const PaginationConfig({
    this.pageSize = 20,
    this.preloadThreshold = 0.8,
    this.maxPreloadPages = 2,
    this.debounceDelay = const Duration(milliseconds: 300),
  });
}

// 무한 스크롤 상태 관리
class InfiniteScrollState {
  final List<ItemModel> items;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;
  final bool isPreloading;
  
  const InfiniteScrollState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 0,
    this.isPreloading = false,
  });
  
  InfiniteScrollState copyWith({
    List<ItemModel>? items,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
    bool? isPreloading,
  }) {
    return InfiniteScrollState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      isPreloading: isPreloading ?? this.isPreloading,
    );
  }
}

// 무한 스크롤 리스트 위젯
class InfiniteScrollList extends ConsumerStatefulWidget {
  final Future<List<ItemModel>> Function(int page, int pageSize) onLoadMore;
  final Widget Function(ItemModel item, int index) itemBuilder;
  final PaginationConfig config;
  final String scrollableId;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool enableRefresh;
  
  const InfiniteScrollList({
    super.key,
    required this.onLoadMore,
    required this.itemBuilder,
    this.config = const PaginationConfig(),
    this.scrollableId = 'default_scroll',
    this.emptyWidget,
    this.errorWidget,
    this.padding,
    this.physics,
    this.enableRefresh = true,
  });

  @override
  ConsumerState<InfiniteScrollList> createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends ConsumerState<InfiniteScrollList> {
  late ScrollController _scrollController;
  late InfiniteScrollState _state;
  Timer? _debounceTimer;
  Timer? _preloadTimer;
  final PerformanceService _performanceService = PerformanceService();
  
  // 성능 최적화를 위한 변수들
  double _lastScrollPosition = 0;
  int _consecutiveFrameDrops = 0;
  bool _isScrolling = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _state = const InfiniteScrollState();
    
    _scrollController.addListener(_onScroll);
    
    // 초기 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
    
    // 성능 모니터링 시작
    _performanceService.startScrollTracking(widget.scrollableId);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounceTimer?.cancel();
    _preloadTimer?.cancel();
    _performanceService.endScrollTracking(widget.scrollableId);
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await _loadPage(0, isInitial: true);
  }

  Future<void> _loadPage(int page, {bool isInitial = false, bool isPreload = false}) async {
    if (_state.isLoading && !isPreload) return;
    
    _performanceService.startOperation('load_page_$page');
    
    setState(() {
      _state = _state.copyWith(
        isLoading: !isPreload,
        isPreloading: isPreload,
        error: null,
      );
    });

    try {
      final newItems = await widget.onLoadMore(page, widget.config.pageSize);
      
      // 이미지 프리로드 (성능 최적화)
      if (newItems.isNotEmpty) {
        final imageUrls = newItems
            .where((item) => item.imageUrl.isNotEmpty)
            .map((item) => item.imageUrl)
            .take(5) // 처음 5개만 프리로드
            .toList();
        
        if (imageUrls.isNotEmpty) {
          ImageCacheService.preloadImages(imageUrls);
        }
      }
      
      setState(() {
        if (isInitial || page == 0) {
          _state = _state.copyWith(
            items: newItems,
            currentPage: 0,
            hasMore: newItems.length == widget.config.pageSize,
            isLoading: false,
            isPreloading: false,
          );
        } else {
          _state = _state.copyWith(
            items: [..._state.items, ...newItems],
            currentPage: page,
            hasMore: newItems.length == widget.config.pageSize,
            isLoading: false,
            isPreloading: false,
          );
        }
      });
      
      _performanceService.endOperation('load_page_$page', additionalData: {
        'items_loaded': newItems.length,
        'total_items': _state.items.length,
        'is_preload': isPreload,
      });
      
    } catch (error) {
      setState(() {
        _state = _state.copyWith(
          error: error.toString(),
          isLoading: false,
          isPreloading: false,
        );
      });
      
      _performanceService.endOperation('load_page_$page', additionalData: {
        'error': error.toString(),
      });
      
      if (mounted) {
        _showErrorSnackBar(error.toString());
      }
    }
  }

  void _onScroll() {
    if (!mounted) return;
    
    final position = _scrollController.position;
    final scrollDelta = (position.pixels - _lastScrollPosition).abs();
    _lastScrollPosition = position.pixels;
    
    // 스크롤 상태 추적
    if (!_isScrolling) {
      _isScrolling = true;
      _performanceService.startScrollTracking('${widget.scrollableId}_session');
    }
    
    // 성능 모니터링: 급격한 스크롤 감지
    if (scrollDelta > 50) {
      _performanceService.startOperation('rapid_scroll');
      _performanceService.endOperation('rapid_scroll', additionalData: {
        'scroll_delta': scrollDelta,
        'scroll_position': position.pixels,
      });
    }
    
    // 디바운싱 적용
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.config.debounceDelay, () {
      if (mounted) {
        _checkLoadConditions();
        _isScrolling = false;
        _performanceService.endScrollTracking('${widget.scrollableId}_session');
      }
    });
  }

  void _checkLoadConditions() {
    if (!mounted || _state.isLoading || !_state.hasMore) return;
    
    final position = _scrollController.position;
    final threshold = position.maxScrollExtent * widget.config.preloadThreshold;
    
    // 스마트 프리로딩: 스크롤 위치와 성능 상태에 따라 조절
    if (position.pixels >= threshold) {
      final canLoadMore = _shouldLoadMore();
      
      if (canLoadMore) {
        _loadPage(_state.currentPage + 1);
      }
    }
    
    // 어드밴스드 프리로딩: 성능이 좋을 때 더 많이 미리 로드
    _schedulePreload();
  }

  bool _shouldLoadMore() {
    // 성능 기반 로딩 결정
    final performanceGood = _performanceService.isPerformanceGood;
    final memoryHealthy = _performanceService.isMemoryHealthy;
    
    // 성능이 나쁘거나 메모리가 부족하면 로딩 보류
    if (!performanceGood || !memoryHealthy) {
      debugPrint('🚫 Loading paused due to performance: FPS=${_performanceService.currentFps.round()}, Memory=${_performanceService.currentMemoryUsageMB}MB');
      return false;
    }
    
    return true;
  }

  void _schedulePreload() {
    if (_state.isPreloading || !_performanceService.isPerformanceGood) return;
    
    _preloadTimer?.cancel();
    _preloadTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted && _state.hasMore && _state.currentPage < widget.config.maxPreloadPages) {
        final nextPage = _state.currentPage + 1;
        _loadPage(nextPage, isPreload: true);
      }
    });
  }

  Future<void> _onRefresh() async {
    if (!widget.enableRefresh) return;
    
    _performanceService.startOperation('refresh_list');
    
    // 이미지 캐시 정리 (메모리 최적화)
    imageCache.clear();
    
    await _loadPage(0, isInitial: true);
    
    _performanceService.endOperation('refresh_list');
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('로딩 중 오류가 발생했습니다: $error'),
        backgroundColor: AppColors.error,
        action: SnackBarAction(
          label: '재시도',
          textColor: Colors.white,
          onPressed: () => _loadPage(_state.currentPage + 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_state.items.isEmpty && _state.isLoading) {
      return _buildLoadingWidget();
    }
    
    if (_state.items.isEmpty && _state.error != null) {
      return widget.errorWidget ?? _buildErrorWidget();
    }
    
    if (_state.items.isEmpty) {
      return widget.emptyWidget ?? _buildEmptyWidget();
    }
    
    return PerformanceWidget(
      operationName: 'infinite_scroll_list',
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: widget.padding ?? EdgeInsets.zero,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // 실제 아이템 렌더링
                    if (index < _state.items.length) {
                      final item = _state.items[index];
                      return _buildOptimizedItem(item, index);
                    }
                    
                    // 로딩 인디케이터
                    if (index == _state.items.length && _state.isLoading) {
                      return _buildLoadingIndicator();
                    }
                    
                    // 에러 위젯
                    if (index == _state.items.length && _state.error != null) {
                      return _buildRetryWidget();
                    }
                    
                    return null;
                  },
                  childCount: _state.items.length + 
                    (_state.isLoading ? 1 : 0) + 
                    (_state.error != null ? 1 : 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizedItem(ItemModel item, int index) {
    // 성능 최적화: AutomaticKeepAlive 적용
    return AutomaticKeepAliveClientMixin.builder(
      key: ValueKey(item.id),
      builder: (context) => PerformanceWidget(
        operationName: 'item_build_$index',
        child: widget.itemBuilder(item, index),
      ),
      wantKeepAlive: index < 10, // 처음 10개 아이템만 메모리에 유지
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            '로딩 중...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            '데이터를 불러올 수 없습니다',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _state.error ?? '알 수 없는 오류가 발생했습니다',
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadInitialData,
            child: const Text('재시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '더 많은 항목을 불러올 수 없습니다',
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _loadPage(_state.currentPage + 1),
            child: const Text('재시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          SizedBox(height: 16),
          Text(
            '표시할 항목이 없습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// AutomaticKeepAlive 헬퍼 클래스
class AutomaticKeepAliveClientMixin {
  static Widget builder({
    required Key key,
    required Widget Function(BuildContext) builder,
    required bool wantKeepAlive,
  }) {
    return wantKeepAlive
        ? _KeepAliveWrapper(key: key, child: Builder(builder: builder))
        : Builder(key: key, builder: builder);
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  
  const _KeepAliveWrapper({
    super.key,
    required this.child,
  });
  
  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper> {
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}