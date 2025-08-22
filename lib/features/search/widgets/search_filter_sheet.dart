import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/teal_components.dart';
import '../../../theme/colors.dart';
import '../../../services/search_service.dart';

class SearchFilterSheet extends ConsumerStatefulWidget {
  final SearchFilters initialFilters;
  final Function(SearchFilters) onFiltersChanged;

  const SearchFilterSheet({
    super.key,
    required this.initialFilters,
    required this.onFiltersChanged,
  });

  @override
  ConsumerState<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends ConsumerState<SearchFilterSheet> {
  late SearchFilters _filters;

  final List<String> _categories = [
    '전체', '카메라', '스포츠', '도구', '주방용품', '완구', 
    '악기', '의류', '가전제품', '도서', '기타'
  ];
  
  final List<String> _locations = [
    '전체', '강남구', '서초구', '송파구', '영등포구', '마포구', 
    '성동구', '광진구', '동작구', '관악구', '서대문구'
  ];

  final List<Map<String, String>> _sortOptions = [
    {'key': 'latest', 'label': '최신순'},
    {'key': 'price_low', 'label': '가격 낮은순'},
    {'key': 'price_high', 'label': '가격 높은순'},
    {'key': 'rating', 'label': '평점 높은순'},
    {'key': 'distance', 'label': '거리순'},
  ];

  // 인기 가격 범위 프리셋
  final List<Map<String, dynamic>> _pricePresets = [
    {'label': '1만원 이하', 'min': 0.0, 'max': 10000.0},
    {'label': '1~5만원', 'min': 10000.0, 'max': 50000.0},
    {'label': '5~10만원', 'min': 50000.0, 'max': 100000.0},
    {'label': '10만원 이상', 'min': 100000.0, 'max': 1000000.0},
  ];

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(),
                  const SizedBox(height: 24),
                  _buildLocationSection(),
                  const SizedBox(height: 24),
                  _buildPriceSection(),
                  const SizedBox(height: 24),
                  _buildDistanceSection(),
                  const SizedBox(height: 24),
                  _buildSortSection(),
                  const SizedBox(height: 24),
                  _buildOptionsSection(),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.separator)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            '검색 필터',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (_filters.hasActiveFilters)
            GestureDetector(
              onTap: _resetFilters,
              child: Text(
                '초기화',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('카테고리'),
        const SizedBox(height: 12),
        TealChipGroup(
          items: _categories,
          selectedItems: [_filters.category],
          multiSelect: false,
          onSelectionChanged: (selected) {
            setState(() {
              _filters = _filters.copyWith(
                category: selected.isNotEmpty ? selected.first : '전체',
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('지역'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _locations.map((location) {
            final isSelected = _filters.location == location;
            return TealChip(
              label: location,
              icon: location == '전체' ? null : Icons.location_on,
              isSelected: isSelected,
              onPressed: () {
                setState(() {
                  _filters = _filters.copyWith(location: location);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('가격 범위'),
        const SizedBox(height: 12),
        
        // 가격 프리셋 칩들
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _pricePresets.map((preset) {
            final isSelected = _filters.minPrice == preset['min'] && 
                              _filters.maxPrice == preset['max'];
            return TealChip(
              label: preset['label'],
              isSelected: isSelected,
              onPressed: () {
                setState(() {
                  _filters = _filters.copyWith(
                    minPrice: preset['min'],
                    maxPrice: preset['max'],
                  );
                });
              },
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        
        // 커스텀 가격 범위 슬라이더
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.tealPale,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_formatPrice(_filters.minPrice.toInt())}원',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '${_formatPrice(_filters.maxPrice.toInt())}원',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              RangeSlider(
                values: RangeValues(_filters.minPrice, _filters.maxPrice),
                min: 0,
                max: 1000000,
                divisions: 100,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.separator,
                onChanged: (RangeValues values) {
                  setState(() {
                    _filters = _filters.copyWith(
                      minPrice: values.start,
                      maxPrice: values.end,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('최대 거리'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.tealPale,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('현재 위치에서'),
                  Text(
                    '${_filters.maxDistance.toInt()}km 이내',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _filters.maxDistance,
                min: 1,
                max: 50,
                divisions: 49,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.separator,
                onChanged: (value) {
                  setState(() {
                    _filters = _filters.copyWith(maxDistance: value);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('정렬'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _sortOptions.map((option) {
            final isSelected = _filters.sortBy == option['key'];
            return TealChip(
              label: option['label']!,
              isSelected: isSelected,
              onPressed: () {
                setState(() {
                  _filters = _filters.copyWith(sortBy: option['key']);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('기타 옵션'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.tealPale,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Switch(
                value: _filters.onlyAvailable,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setState(() {
                    _filters = _filters.copyWith(onlyAvailable: value);
                  });
                },
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '대여 가능한 물건만 보기',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.separator)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TealButton.outline(
              text: '취소',
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: TealButton(
              text: _filters.hasActiveFilters 
                ? '필터 적용 (${_filters.activeFilterCount})'
                : '필터 적용',
              onPressed: _applyFilters,
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _filters = SearchFilters.defaultFilters();
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
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