import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/teal_components.dart';
import '../../../theme/colors.dart';
import '../../../services/search_service.dart';

class SearchNoResults extends ConsumerWidget {
  final String query;
  final SearchFilters filters;
  final Function(String) onSuggestionTap;
  final VoidCallback onClearFilters;
  final VoidCallback onExpandSearch;

  const SearchNoResults({
    super.key,
    required this.query,
    required this.filters,
    required this.onSuggestionTap,
    required this.onClearFilters,
    required this.onExpandSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildNoResultsIcon(),
          const SizedBox(height: 20),
          _buildNoResultsText(context),
          const SizedBox(height: 32),
          _buildSuggestions(context),
          const SizedBox(height: 24),
          _buildActionButtons(context),
          const SizedBox(height: 32),
          _buildAlternativeSearches(context),
        ],
      ),
    );
  }

  Widget _buildNoResultsIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.tealPale,
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Icon(
        Icons.search_off,
        size: 40,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildNoResultsText(BuildContext context) {
    return Column(
      children: [
        Text(
          '"$query" 검색 결과가 없습니다',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '다른 키워드로 검색하거나\n필터 조건을 변경해보세요',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    final suggestions = _generateSuggestions();
    
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이런 검색어는 어떠세요?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((suggestion) {
            return TealChip(
              label: suggestion,
              type: TealChipType.outline,
              onPressed: () => onSuggestionTap(suggestion),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (filters.hasActiveFilters) ...[
          SizedBox(
            width: double.infinity,
            child: TealButton(
              text: '필터 초기화하고 다시 검색',
              onPressed: onClearFilters,
              iconData: Icons.filter_alt_off,
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: TealButton.outline(
            text: '검색 범위 확대',
            onPressed: onExpandSearch,
            iconData: Icons.zoom_out_map,
          ),
        ),
      ],
    );
  }

  Widget _buildAlternativeSearches(BuildContext context) {
    final alternatives = _getAlternativeSearches();
    
    if (alternatives.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '대신 이런 물건들은 어떠세요?',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...alternatives.map((category) => _buildCategoryCard(context, category)),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.separator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                category['icon'] as IconData,
                size: 24,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Text(
                category['name'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: (category['items'] as List<String>).map((item) {
              return TealChip(
                label: item,
                type: TealChipType.secondary,
                size: TealChipSize.small,
                onPressed: () => onSuggestionTap(item),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<String> _generateSuggestions() {
    final suggestions = <String>[];
    final queryWords = query.toLowerCase().split(' ');
    
    // 키워드 기반 제안
    final keywordSuggestions = {
      'camera': ['DSLR', '미러리스', '렌즈', '삼각대'],
      'laptop': ['맥북', '노트북', '태블릿', '모니터'],
      'sport': ['자전거', '헬스기구', '골프용품', '축구공'],
      'tent': ['캠핑', '텐트', '침낭', '랜턴'],
      'book': ['소설', '자기계발', '요리책', '만화책'],
    };
    
    for (final word in queryWords) {
      if (word.contains('카메라') || word.contains('camera')) {
        suggestions.addAll(keywordSuggestions['camera'] ?? []);
      } else if (word.contains('맥북') || word.contains('laptop')) {
        suggestions.addAll(keywordSuggestions['laptop'] ?? []);
      } else if (word.contains('스포츠') || word.contains('sport')) {
        suggestions.addAll(keywordSuggestions['sport'] ?? []);
      } else if (word.contains('텐트') || word.contains('tent')) {
        suggestions.addAll(keywordSuggestions['tent'] ?? []);
      } else if (word.contains('책') || word.contains('book')) {
        suggestions.addAll(keywordSuggestions['book'] ?? []);
      }
    }
    
    // 중복 제거 및 제한
    return suggestions.toSet().take(6).toList();
  }

  List<Map<String, dynamic>> _getAlternativeSearches() {
    // 현재 카테고리나 검색어와 관련된 대안 카테고리 제안
    if (filters.category != '전체') {
      return _getRelatedCategories(filters.category);
    }
    
    // 인기 카테고리 제안
    return [
      {
        'name': '카메라',
        'icon': Icons.camera_alt,
        'items': ['DSLR', '미러리스', '렌즈', '삼각대'],
      },
      {
        'name': '스포츠',
        'icon': Icons.sports_basketball,
        'items': ['자전거', '헬스기구', '골프용품', '축구공'],
      },
      {
        'name': '캠핑용품',
        'icon': Icons.cabin,
        'items': ['텐트', '침낭', '랜턴', '버너'],
      },
    ];
  }

  List<Map<String, dynamic>> _getRelatedCategories(String category) {
    final relatedCategories = {
      '카메라': [
        {
          'name': '스포츠',
          'icon': Icons.sports_basketball,
          'items': ['액션캠', '드론', '스포츠카메라', '삼각대'],
        },
        {
          'name': '도구',
          'icon': Icons.build,
          'items': ['조명', '반사판', '카메라청소용품', '가방'],
        },
      ],
      '스포츠': [
        {
          'name': '캠핑용품',
          'icon': Icons.cabin,
          'items': ['텐트', '침낭', '등산용품', '낚시용품'],
        },
        {
          'name': '의류',
          'icon': Icons.checkroom,
          'items': ['운동복', '등산복', '자전거복', '운동화'],
        },
      ],
      '주방용품': [
        {
          'name': '가전제품',
          'icon': Icons.kitchen,
          'items': ['믹서기', '전자레인지', '에어프라이어', '커피머신'],
        },
        {
          'name': '캠핑용품',
          'icon': Icons.cabin,
          'items': ['캠핑조리기구', '쿨러', '버너', '식기'],
        },
      ],
    };
    
    return relatedCategories[category] ?? [];
  }
}