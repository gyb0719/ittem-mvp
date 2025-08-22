import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_suggestion.dart';
import '../services/search_suggestions_service.dart';

class SearchSuggestionsList extends ConsumerWidget {
  final String query;
  final Function(String) onSuggestionTap;
  final Function(String)? onSuggestionRemove;
  final EdgeInsets? padding;

  const SearchSuggestionsList({
    super.key,
    required this.query,
    required this.onSuggestionTap,
    this.onSuggestionRemove,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsAsync = ref.watch(searchSuggestionsProvider(query));
    
    return suggestionsAsync.when(
      data: (suggestions) => _buildSuggestionsList(context, suggestions),
      loading: () => _buildLoadingSuggestions(context),
      error: (error, stack) => _buildErrorSuggestions(context, error),
    );
  }

  Widget _buildSuggestionsList(BuildContext context, List<SearchSuggestion> suggestions) {
    if (suggestions.isEmpty) {
      return _buildNoSuggestions(context);
    }

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 그룹화된 제안들
          ..._groupSuggestions(suggestions).entries.map(
            (entry) => _buildSuggestionGroup(context, entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Map<SearchSuggestionType, List<SearchSuggestion>> _groupSuggestions(
      List<SearchSuggestion> suggestions) {
    final grouped = <SearchSuggestionType, List<SearchSuggestion>>{};
    
    for (final suggestion in suggestions) {
      grouped.putIfAbsent(suggestion.type, () => []).add(suggestion);
    }
    
    return grouped;
  }

  Widget _buildSuggestionGroup(BuildContext context, SearchSuggestionType type, 
      List<SearchSuggestion> suggestions) {
    final groupTitle = _getGroupTitle(type);
    final groupIcon = _getGroupIcon(type);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 그룹 헤더
        if (suggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Icon(
                  groupIcon,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  groupTitle,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        
        // 제안 아이템들
        ...suggestions.map((suggestion) => _buildSuggestionItem(context, suggestion)),
        
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildSuggestionItem(BuildContext context, SearchSuggestion suggestion) {
    final isRecent = suggestion.type == SearchSuggestionType.recent;
    final isPopular = suggestion.type == SearchSuggestionType.popular;
    
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: _buildSuggestionIcon(context, suggestion),
      title: _buildSuggestionTitle(context, suggestion),
      subtitle: _buildSuggestionSubtitle(context, suggestion),
      trailing: isRecent 
          ? IconButton(
              icon: Icon(
                Icons.close,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () => onSuggestionRemove?.call(suggestion.text),
              splashRadius: 16,
            )
          : (suggestion.resultsCount > 0 
              ? _buildResultCount(context, suggestion.resultsCount)
              : null),
      onTap: () => onSuggestionTap(suggestion.text),
    );
  }

  Widget _buildSuggestionIcon(BuildContext context, SearchSuggestion suggestion) {
    IconData icon;
    Color? iconColor;
    
    switch (suggestion.type) {
      case SearchSuggestionType.recent:
        icon = Icons.history;
        iconColor = Theme.of(context).colorScheme.onSurfaceVariant;
        break;
      case SearchSuggestionType.popular:
        icon = Icons.trending_up;
        iconColor = Theme.of(context).colorScheme.primary;
        break;
      case SearchSuggestionType.category:
        icon = Icons.category_outlined;
        iconColor = Colors.orange;
        break;
      case SearchSuggestionType.brand:
        icon = Icons.business_outlined;
        iconColor = Colors.blue;
        break;
      case SearchSuggestionType.location:
        icon = Icons.location_on_outlined;
        iconColor = Colors.green;
        break;
      case SearchSuggestionType.autocomplete:
        icon = Icons.search;
        iconColor = Theme.of(context).colorScheme.onSurfaceVariant;
        break;
      default:
        icon = Icons.search;
        iconColor = Theme.of(context).colorScheme.onSurfaceVariant;
    }
    
    return Icon(icon, size: 20, color: iconColor);
  }

  Widget _buildSuggestionTitle(BuildContext context, SearchSuggestion suggestion) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: _highlightSearchTerm(suggestion.text, query),
      ),
    );
  }

  Widget? _buildSuggestionSubtitle(BuildContext context, SearchSuggestion suggestion) {
    if (suggestion.category != null && suggestion.type != SearchSuggestionType.category) {
      return Text(
        suggestion.category!,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    return null;
  }

  Widget _buildResultCount(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  List<TextSpan> _highlightSearchTerm(String text, String searchTerm) {
    if (searchTerm.trim().isEmpty) {
      return [TextSpan(text: text)];
    }

    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerSearchTerm = searchTerm.toLowerCase().trim();
    
    int start = 0;
    int index = lowerText.indexOf(lowerSearchTerm);
    
    while (index >= 0) {
      // 매치 이전 텍스트
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      
      // 매치된 텍스트 (하이라이트)
      spans.add(TextSpan(
        text: text.substring(index, index + searchTerm.length),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        ),
      ));
      
      start = index + searchTerm.length;
      index = lowerText.indexOf(lowerSearchTerm, start);
    }
    
    // 남은 텍스트
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    
    return spans;
  }

  String _getGroupTitle(SearchSuggestionType type) {
    switch (type) {
      case SearchSuggestionType.recent:
        return '최근 검색어';
      case SearchSuggestionType.popular:
        return '인기 검색어';
      case SearchSuggestionType.category:
        return '카테고리';
      case SearchSuggestionType.brand:
        return '브랜드';
      case SearchSuggestionType.location:
        return '지역';
      case SearchSuggestionType.autocomplete:
        return '자동완성';
      default:
        return '검색 제안';
    }
  }

  IconData _getGroupIcon(SearchSuggestionType type) {
    switch (type) {
      case SearchSuggestionType.recent:
        return Icons.history;
      case SearchSuggestionType.popular:
        return Icons.trending_up;
      case SearchSuggestionType.category:
        return Icons.category;
      case SearchSuggestionType.brand:
        return Icons.business;
      case SearchSuggestionType.location:
        return Icons.location_on;
      case SearchSuggestionType.autocomplete:
        return Icons.search;
      default:
        return Icons.lightbulb_outline;
    }
  }

  Widget _buildLoadingSuggestions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildErrorSuggestions(BuildContext context, Object error) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 20,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '제안을 불러올 수 없습니다',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSuggestions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.search_off,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '검색 제안이 없습니다',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 빈 상태에서 보여줄 제안들
class EmptyStateSearchSuggestions extends ConsumerWidget {
  final Function(String) onSuggestionTap;
  final Function(String)? onRecentSearchRemove;

  const EmptyStateSearchSuggestions({
    super.key,
    required this.onSuggestionTap,
    this.onRecentSearchRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchHistory = ref.watch(searchHistoryProvider);
    final popularSearchesAsync = ref.watch(popularSearchesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 최근 검색어
          if (searchHistory.isNotEmpty) ...[
            _buildSectionHeader(context, '최근 검색어', Icons.history, () {
              ref.read(searchHistoryProvider.notifier).clearHistory();
            }),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: searchHistory.take(10).map((history) => 
                _buildSearchChip(
                  context,
                  history.query,
                  onTap: () => onSuggestionTap(history.query),
                  onRemove: () => onRecentSearchRemove?.call(history.query),
                ),
              ).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // 인기 검색어
          _buildSectionHeader(context, '인기 검색어', Icons.trending_up),
          const SizedBox(height: 8),
          popularSearchesAsync.when(
            data: (popularSearches) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: popularSearches.take(8).map((popular) =>
                _buildSearchChip(
                  context,
                  popular.query,
                  isPopular: true,
                  onTap: () => onSuggestionTap(popular.query),
                ),
              ).toList(),
            ),
            loading: () => _buildChipsLoading(context),
            error: (error, stack) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),

          // 추천 카테고리
          _buildSectionHeader(context, '추천 카테고리', Icons.category),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _getRecommendedCategories().map((category) =>
              _buildSearchChip(
                context,
                category,
                isCategory: true,
                onTap: () => onSuggestionTap(category),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, [VoidCallback? onAction]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              '전체 삭제',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchChip(
    BuildContext context,
    String text, {
    bool isPopular = false,
    bool isCategory = false,
    required VoidCallback onTap,
    VoidCallback? onRemove,
  }) {
    Color? backgroundColor;
    Color? foregroundColor;
    Widget? avatar;

    if (isPopular) {
      backgroundColor = Theme.of(context).colorScheme.primaryContainer;
      foregroundColor = Theme.of(context).colorScheme.onPrimaryContainer;
      avatar = Icon(
        Icons.trending_up,
        size: 16,
        color: Theme.of(context).colorScheme.primary,
      );
    } else if (isCategory) {
      backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
      foregroundColor = Theme.of(context).colorScheme.onSecondaryContainer;
      avatar = Icon(
        Icons.category,
        size: 16,
        color: Theme.of(context).colorScheme.secondary,
      );
    } else {
      backgroundColor = Theme.of(context).colorScheme.surfaceVariant;
      foregroundColor = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return ActionChip(
      avatar: avatar,
      label: Text(text),
      backgroundColor: backgroundColor,
      labelStyle: TextStyle(
        color: foregroundColor,
        fontSize: 14,
      ),
      onPressed: onTap,
      deleteIcon: onRemove != null 
          ? Icon(Icons.close, size: 16, color: foregroundColor)
          : null,
      onDeleted: onRemove,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildChipsLoading(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(6, (index) => Container(
        width: 80,
        height: 32,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
      )),
    );
  }

  List<String> _getRecommendedCategories() {
    return [
      '카메라',
      '스포츠',
      '가전제품',
      '완구',
      '도구',
      '주방용품',
      '악기',
      '의류',
    ];
  }
}