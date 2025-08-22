import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/item_model.dart';
import '../../../shared/widgets/cards/cards.dart';
import '../../../shared/widgets/skeleton/skeleton_widgets.dart';
import '../../../app/routes/app_routes.dart';
import '../models/search_result.dart';
import '../services/search_analytics_service.dart';

enum SearchResultsViewMode {
  grid,
  list,
  map,
}

class SearchResultsGrid extends ConsumerStatefulWidget {
  final SearchResult searchResult;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final Function()? onRetry;
  final Function()? onLoadMore;
  final bool hasMore;
  final SearchResultsViewMode viewMode;
  final Function(SearchResultsViewMode)? onViewModeChanged;
  final String searchQuery;

  const SearchResultsGrid({
    super.key,
    required this.searchResult,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.onRetry,
    this.onLoadMore,
    this.hasMore = true,
    this.viewMode = SearchResultsViewMode.grid,
    this.onViewModeChanged,
    required this.searchQuery,
  });

  @override
  ConsumerState<SearchResultsGrid> createState() => _SearchResultsGridState();
}

class _SearchResultsGridState extends ConsumerState<SearchResultsGrid> {
  late ScrollController _scrollController;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      if (!widget.isLoading && widget.hasMore) {
        widget.onLoadMore?.call();
      }
    }
  }

  void _onItemTap(ItemModel item, int index) {
    // 검색 결과 클릭 추적
    final analytics = ref.read(searchAnalyticsServiceProvider);
    analytics.trackResultClick(
      query: widget.searchQuery,
      itemId: item.id,
      position: index + 1,
    );
    
    context.go(AppRoutes.itemDetail(item.id));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasError) {
      return _buildErrorState();
    }

    if (widget.isLoading && widget.searchResult.items.isEmpty) {
      return _buildLoadingState();
    }

    if (widget.searchResult.items.isEmpty && !widget.isLoading) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildResultsHeader(),
        Expanded(
          child: _buildResultsContent(),
        ),
      ],
    );
  }

  Widget _buildResultsHeader() {
    final metadata = widget.searchResult.metadata;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // 검색 결과 정보 및 뷰 모드 변경
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '검색결과 ${metadata.totalCount}개',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (metadata.searchTime > 0)
                      Text(
                        '${(metadata.searchTime / 1000).toStringAsFixed(2)}초',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              
              // 뷰 모드 변경 버튼들
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.grid_view,
                      color: widget.viewMode == SearchResultsViewMode.grid
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => widget.onViewModeChanged?.call(SearchResultsViewMode.grid),
                    tooltip: '그리드 뷰',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.list,
                      color: widget.viewMode == SearchResultsViewMode.list
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => widget.onViewModeChanged?.call(SearchResultsViewMode.list),
                    tooltip: '리스트 뷰',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.map,
                      color: widget.viewMode == SearchResultsViewMode.map
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => widget.onViewModeChanged?.call(SearchResultsViewMode.map),
                    tooltip: '지도 뷰',
                  ),
                ],
              ),
            ],
          ),
          
          // 맞춤법 교정 제안
          if (metadata.hasSpellCorrection && metadata.correctedQuery != null)
            _buildSpellCorrectionSuggestion(),
            
          // 검색 개선 제안
          if (metadata.totalCount < 5)
            _buildSearchImprovementSuggestion(),
        ],
      ),
    );
  }

  Widget _buildSpellCorrectionSuggestion() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.spellcheck,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: '이것을 찾으셨나요? '),
                  TextSpan(
                    text: widget.searchResult.metadata.correctedQuery!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: 교정된 검색어로 다시 검색
            },
            child: const Text('검색'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchImprovementSuggestion() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '검색 결과가 적습니다. 다른 키워드를 시도하거나 필터를 조정해보세요.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsContent() {
    switch (widget.viewMode) {
      case SearchResultsViewMode.grid:
        return _buildGridView();
      case SearchResultsViewMode.list:
        return _buildListView();
      case SearchResultsViewMode.map:
        return _buildMapView();
    }
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: widget.searchResult.items.length + (widget.isLoading ? 4 : 0),
      itemBuilder: (context, index) {
        if (index >= widget.searchResult.items.length) {
          return const SkeletonItemCard();
        }
        
        final item = widget.searchResult.items[index];
        return ItemCardGrid(
          item: item,
          showFavorite: true,
          onFavoriteToggled: (isFavorite) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isFavorite ? '즐겨찾기에 추가했습니다' : '즐겨찾기에서 제거했습니다'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          onTap: () => _onItemTap(item, index),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: widget.searchResult.items.length + (widget.isLoading ? 3 : 0),
      itemBuilder: (context, index) {
        if (index >= widget.searchResult.items.length) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: SkeletonItemCard(),
          );
        }
        
        final item = widget.searchResult.items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ItemCardCompact(
            item: item,
            showFavorite: true,
            onFavoriteToggled: (isFavorite) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorite ? '즐겨찾기에 추가했습니다' : '즐겨찾기에서 제거했습니다'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            onTap: () => _onItemTap(item, index),
          ),
        );
      },
    );
  }

  Widget _buildMapView() {
    // TODO: 지도 뷰 구현 (Google Maps 연동)
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('지도 뷰 준비 중입니다'),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        // 헤더 스켈레톤
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SkeletonText.title(width: 120),
              Row(
                children: List.generate(3, (index) => 
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: SkeletonBox(width: 40, height: 40, borderRadius: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 그리드 스켈레톤
        Expanded(
          child: SkeletonGrid(
            itemCount: 8,
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            '검색 중 오류가 발생했습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          if (widget.errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: widget.onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            Text(
              '검색 결과가 없습니다',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"${widget.searchQuery}"에 대한 검색 결과를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            _buildSearchTips(),
            
            const SizedBox(height: 32),
            
            _buildAlternativeSuggestions(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTips() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '검색 팁',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          ...[
            '더 일반적인 키워드를 사용해보세요',
            '맞춤법을 확인해보세요',
            '필터 조건을 완화해보세요',
            '다른 카테고리에서 찾아보세요',
          ].map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 8, right: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    tip,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildAlternativeSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이런 카테고리는 어떠세요?',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            '카메라', '스포츠', '가전제품', '완구', '도구', '주방용품'
          ].map((category) => ActionChip(
            label: Text(category),
            onPressed: () {
              // TODO: 카테고리로 검색
            },
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          )).toList(),
        ),
      ],
    );
  }
}

// 검색 결과 통계 위젯
class SearchResultsStats extends StatelessWidget {
  final SearchResult searchResult;
  final String searchQuery;

  const SearchResultsStats({
    super.key,
    required this.searchResult,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final metadata = searchResult.metadata;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '검색 통계',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildStatRow(
            context,
            '전체 결과',
            '${metadata.totalCount}개',
            Icons.search,
          ),
          _buildStatRow(
            context,
            '검색 시간',
            '${(metadata.searchTime / 1000).toStringAsFixed(2)}초',
            Icons.timer,
          ),
          if (metadata.searchTerms != null && metadata.searchTerms!.isNotEmpty)
            _buildStatRow(
              context,
              '검색 키워드',
              metadata.searchTerms!.join(', '),
              Icons.label,
            ),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}