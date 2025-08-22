import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/teal_components.dart';
import '../../../theme/colors.dart';
import '../../../services/search_service.dart';

class SearchSuggestions extends ConsumerWidget {
  final String query;
  final List<String> searchHistory;
  final Function(String) onSuggestionTap;
  final Function(String) onHistoryRemove;
  final VoidCallback? onClearHistory;

  const SearchSuggestions({
    super.key,
    required this.query,
    required this.searchHistory,
    required this.onSuggestionTap,
    required this.onHistoryRemove,
    this.onClearHistory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchService = ref.read(searchServiceProvider);
    
    if (query.isEmpty) {
      return _buildSearchHistory(context);
    } else {
      final suggestions = searchService.getSearchSuggestions(query, searchHistory);
      return _buildSuggestions(context, suggestions);
    }
  }

  Widget _buildSearchHistory(BuildContext context) {
    if (searchHistory.isEmpty) {
      return _buildEmptyState(context);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            context,
            '최근 검색어',
            onClearHistory != null
                ? TextButton(
                    onPressed: onClearHistory,
                    child: Text(
                      '전체 삭제',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          ...searchHistory.take(10).map((search) => _buildHistoryItem(search)),
          const SizedBox(height: 24),
          _buildPopularSearches(context),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context, List<String> suggestions) {
    if (suggestions.isEmpty) {
      return _buildNoSuggestions(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return _buildSuggestionItem(suggestion);
      },
    );
  }

  Widget _buildHistoryItem(String search) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onSuggestionTap(search),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.history,
                size: 20,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  search,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onHistoryRemove(search),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return InkWell(
      onTap: () => onSuggestionTap(suggestion),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: _highlightQuery(suggestion, query),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.north_west,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSearches(BuildContext context) {
    // 인기 검색어 (실제로는 서버에서 가져오거나 로컬 통계로 생성)
    final popularSearches = [
      'DSLR 카메라', '맥북', '아이패드', '텐트', '캠핑용품',
      '스피커', '헤드폰', '자전거', '운동기구', '책상'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, '인기 검색어', null),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: popularSearches.take(8).map((search) {
            return TealChip(
              label: search,
              type: TealChipType.outline,
              size: TealChipSize.small,
              onPressed: () => onSuggestionTap(search),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, Widget? action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (action != null) action,
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              '최근 검색어가 없습니다',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '찾고 있는 물건을 검색해보세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            _buildPopularSearches(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSuggestions(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              '검색 제안이 없습니다',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '다른 키워드로 검색해보세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _highlightQuery(String text, String query) {
    if (query.isEmpty) {
      return [TextSpan(text: text)];
    }

    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();
    final spans = <TextSpan>[];
    
    int start = 0;
    int index = textLower.indexOf(queryLower);
    
    while (index != -1) {
      // 매치 이전 텍스트
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
        ));
      }
      
      // 매치된 텍스트 (하이라이트)
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ));
      
      start = index + query.length;
      index = textLower.indexOf(queryLower, start);
    }
    
    // 나머지 텍스트
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
      ));
    }
    
    return spans;
  }
}

// 카테고리별 인기 검색어 위젯
class CategoryPopularSearches extends ConsumerWidget {
  final String category;
  final Function(String) onSearchTap;

  const CategoryPopularSearches({
    super.key,
    required this.category,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchService = ref.read(searchServiceProvider);
    final popularByCategory = searchService.getPopularByCategory();
    final categorySearches = popularByCategory[category] ?? [];

    if (categorySearches.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.tealPale,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$category 인기 검색어',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: categorySearches.map((search) {
              return TealChip(
                label: search,
                type: TealChipType.secondary,
                size: TealChipSize.small,
                onPressed: () => onSearchTap(search),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}