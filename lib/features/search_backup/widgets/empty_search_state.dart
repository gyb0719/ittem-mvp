import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/search_suggestions_service.dart';

class EmptySearchState extends ConsumerWidget {
  final Function(String) onSearchTap;
  final Function(String) onCategoryTap;
  final Function(String)? onRecentSearchRemove;

  const EmptySearchState({
    super.key,
    required this.onSearchTap,
    required this.onCategoryTap,
    this.onRecentSearchRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchHistory = ref.watch(searchHistoryProvider);
    final popularSearchesAsync = ref.watch(popularSearchesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 환영 메시지
          _buildWelcomeSection(context),
          const SizedBox(height: 32),

          // 최근 검색어
          if (searchHistory.isNotEmpty) ...[
            _buildRecentSearches(context, searchHistory),
            const SizedBox(height: 32),
          ],

          // 인기 검색어
          _buildPopularSearches(context, popularSearchesAsync),
          const SizedBox(height: 32),

          // 추천 카테고리
          _buildRecommendedCategories(context),
          const SizedBox(height: 32),

          // 검색 팁
          _buildSearchTips(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '무엇을 찾고 계신가요?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '필요한 물건을 검색하거나 카테고리를 둘러보세요.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearches(BuildContext context, List<SearchHistory> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '최근 검색어',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // 전체 삭제 확인 다이얼로그
                _showClearHistoryDialog(context);
              },
              child: Text(
                '전체 삭제',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: history.take(8).map((searchHistory) {
            return _buildSearchChip(
              context,
              searchHistory.query,
              icon: Icons.history,
              onTap: () => onSearchTap(searchHistory.query),
              onRemove: onRecentSearchRemove != null
                  ? () => onRecentSearchRemove!(searchHistory.query)
                  : null,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPopularSearches(BuildContext context, AsyncValue<List<PopularSearch>> popularSearchesAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '인기 검색어',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        popularSearchesAsync.when(
          data: (popularSearches) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: popularSearches.take(8).map((popular) {
                return _buildSearchChip(
                  context,
                  popular.query,
                  icon: Icons.trending_up,
                  isPopular: true,
                  onTap: () => onSearchTap(popular.query),
                );
              }).toList(),
            );
          },
          loading: () => _buildLoadingChips(context, 8),
          error: (error, stack) => _buildErrorState(context, '인기 검색어를 불러올 수 없습니다'),
        ),
      ],
    );
  }

  Widget _buildRecommendedCategories(BuildContext context) {
    final categories = [
      {'name': '카메라', 'icon': Icons.camera_alt, 'color': Colors.blue},
      {'name': '스포츠', 'icon': Icons.sports_soccer, 'color': Colors.green},
      {'name': '가전제품', 'icon': Icons.devices, 'color': Colors.purple},
      {'name': '완구', 'icon': Icons.toys, 'color': Colors.orange},
      {'name': '도구', 'icon': Icons.build, 'color': Colors.brown},
      {'name': '주방용품', 'icon': Icons.kitchen, 'color': Colors.red},
      {'name': '악기', 'icon': Icons.music_note, 'color': Colors.indigo},
      {'name': '의류', 'icon': Icons.checkroom, 'color': Colors.pink},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.category,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '인기 카테고리',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(
              context,
              category['name'] as String,
              category['icon'] as IconData,
              category['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, String name, IconData icon, Color color) {
    return InkWell(
      onTap: () => onCategoryTap(name),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTips(BuildContext context) {
    final tips = [
      {
        'icon': Icons.search,
        'title': '정확한 검색',
        'description': '브랜드명이나 모델명을 포함해서 검색해보세요',
      },
      {
        'icon': Icons.location_on,
        'title': '위치 기반 검색',
        'description': '내 주변의 상품을 우선적으로 보여드려요',
      },
      {
        'icon': Icons.filter_alt,
        'title': '필터 활용',
        'description': '가격, 카테고리, 상태 등으로 결과를 세밀하게 조정하세요',
      },
      {
        'icon': Icons.favorite,
        'title': '관심 상품',
        'description': '마음에 드는 상품은 즐겨찾기에 추가해두세요',
      },
    ];

    return Column(
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...tips.map((tip) => _buildTipCard(
          context,
          tip['icon'] as IconData,
          tip['title'] as String,
          tip['description'] as String,
        )).toList(),
      ],
    );
  }

  Widget _buildTipCard(BuildContext context, IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(
    BuildContext context,
    String text, {
    IconData? icon,
    bool isPopular = false,
    required VoidCallback onTap,
    VoidCallback? onRemove,
  }) {
    Color backgroundColor;
    Color foregroundColor;
    
    if (isPopular) {
      backgroundColor = Theme.of(context).colorScheme.primaryContainer;
      foregroundColor = Theme.of(context).colorScheme.onPrimaryContainer;
    } else {
      backgroundColor = Theme.of(context).colorScheme.surfaceVariant;
      foregroundColor = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return ActionChip(
      avatar: icon != null
          ? Icon(icon, size: 16, color: foregroundColor)
          : null,
      label: Text(text),
      backgroundColor: backgroundColor,
      labelStyle: TextStyle(
        color: foregroundColor,
        fontSize: 14,
        fontWeight: isPopular ? FontWeight.w500 : FontWeight.normal,
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

  Widget _buildLoadingChips(BuildContext context, int count) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(count, (index) {
        return Container(
          width: 60 + (index % 3) * 20,
          height: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      }),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
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
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('검색 기록 삭제'),
          content: const Text('모든 검색 기록을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // TODO: 검색 기록 전체 삭제
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('검색 기록이 삭제되었습니다'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }
}

// 검색 결과 없음 상태
class NoSearchResultsState extends StatelessWidget {
  final String query;
  final Map<String, dynamic>? appliedFilters;
  final Function(String) onSuggestionTap;
  final VoidCallback? onClearFilters;
  final VoidCallback? onBroaderSearch;

  const NoSearchResultsState({
    super.key,
    required this.query,
    this.appliedFilters,
    required this.onSuggestionTap,
    this.onClearFilters,
    this.onBroaderSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // 빈 상태 일러스트
            Icon(
              Icons.search_off,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            
            // 제목과 설명
            Text(
              '검색 결과가 없습니다',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"$query"에 대한 검색 결과를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // 제안 및 액션 버튼들
            _buildSuggestionActions(context),
            const SizedBox(height: 32),

            // 검색 개선 팁
            _buildSearchImprovementTips(context),
            const SizedBox(height: 32),

            // 관련 카테고리 제안
            _buildRelatedCategories(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '다음을 시도해보세요',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              if (onBroaderSearch != null)
                _buildActionButton(
                  context,
                  '더 넓게 검색',
                  Icons.zoom_out,
                  onBroaderSearch!,
                ),
              if (onClearFilters != null && _hasActiveFilters())
                _buildActionButton(
                  context,
                  '필터 해제',
                  Icons.filter_alt_off,
                  onClearFilters!,
                ),
              _buildActionButton(
                context,
                '맞춤법 확인',
                Icons.spellcheck,
                () => _showSpellingSuggestions(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget _buildSearchImprovementTips(BuildContext context) {
    final tips = [
      '더 일반적인 키워드 사용',
      '단어 수를 줄이기',
      '동의어나 유사 단어 시도',
      '오타나 띄어쓰기 확인',
    ];

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
                '검색 개선 팁',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    tip,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildRelatedCategories(BuildContext context) {
    final relatedCategories = _getRelatedCategories(query);
    
    if (relatedCategories.isEmpty) {
      return const SizedBox.shrink();
    }

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
          children: relatedCategories.map((category) {
            return ActionChip(
              label: Text(category),
              onPressed: () => onSuggestionTap(category),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  bool _hasActiveFilters() {
    if (appliedFilters == null) return false;
    
    return appliedFilters!.entries.any((entry) {
      switch (entry.key) {
        case 'category':
          return entry.value != '전체';
        case 'location':
          return entry.value != '전체';
        case 'minPrice':
          return entry.value > 0;
        case 'maxPrice':
          return entry.value < 100000;
        case 'onlyAvailable':
          return entry.value != true;
        default:
          return entry.value != null;
      }
    });
  }

  List<String> _getRelatedCategories(String searchQuery) {
    final keywordCategories = {
      'camera': ['카메라', '가전제품'],
      'tent': ['스포츠', '캠핑'],
      'laptop': ['가전제품', '컴퓨터'],
      'toy': ['완구', '아기용품'],
      'book': ['도서', '교육'],
      'kitchen': ['주방용품', '생활용품'],
      'music': ['악기', '음향장비'],
      'clothes': ['의류', '패션'],
    };

    final lowerQuery = searchQuery.toLowerCase();
    final categories = <String>{};
    
    keywordCategories.forEach((keyword, relatedCategories) {
      if (lowerQuery.contains(keyword)) {
        categories.addAll(relatedCategories);
      }
    });
    
    // 기본 추천 카테고리
    if (categories.isEmpty) {
      categories.addAll(['카메라', '스포츠', '가전제품', '완구']);
    }
    
    return categories.take(6).toList();
  }

  void _showSpellingSuggestions(BuildContext context) {
    // TODO: 실제 맞춤법 교정 제안 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('맞춤법 교정 기능을 준비 중입니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}