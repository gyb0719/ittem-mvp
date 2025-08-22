import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_filter.dart';
import '../../../shared/widgets/teal_components.dart';

class SearchFiltersPanel extends ConsumerStatefulWidget {
  final Map<String, dynamic> initialFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;
  final VoidCallback? onReset;
  final VoidCallback? onApply;

  const SearchFiltersPanel({
    super.key,
    required this.initialFilters,
    required this.onFiltersChanged,
    this.onReset,
    this.onApply,
  });

  @override
  ConsumerState<SearchFiltersPanel> createState() => _SearchFiltersPanelState();
}

class _SearchFiltersPanelState extends ConsumerState<SearchFiltersPanel> {
  late Map<String, dynamic> _currentFilters;
  
  // 필터 옵션들
  final List<String> _categories = [
    '전체', '카메라', '스포츠', '도구', '주방용품', '완구', '악기', '의류', '가전제품', '도서', '기타'
  ];
  
  final List<String> _locations = [
    '전체', '강남구', '서초구', '송파구', '영등포구', '마포구', '성동구', '광진구', '동작구', '관악구', '서대문구'
  ];

  final List<Map<String, String>> _sortOptions = [
    {'key': 'latest', 'label': '최신순'},
    {'key': 'price_low', 'label': '가격 낮은순'},
    {'key': 'price_high', 'label': '가격 높은순'},
    {'key': 'rating', 'label': '평점 높은순'},
    {'key': 'distance', 'label': '거리순'},
  ];

  final List<Map<String, dynamic>> _conditionOptions = [
    {'key': 'all', 'label': '전체', 'icon': Icons.all_inclusive},
    {'key': 'new', 'label': '새상품', 'icon': Icons.fiber_new},
    {'key': 'like_new', 'label': '거의 새것', 'icon': Icons.star},
    {'key': 'good', 'label': '좋음', 'icon': Icons.thumb_up},
    {'key': 'fair', 'label': '보통', 'icon': Icons.thumbs_up_down},
  ];

  @override
  void initState() {
    super.initState();
    _currentFilters = Map.from(widget.initialFilters);
  }

  void _updateFilter(String key, dynamic value) {
    setState(() {
      _currentFilters[key] = value;
    });
    widget.onFiltersChanged(_currentFilters);
  }

  void _resetFilters() {
    setState(() {
      _currentFilters = {
        'category': '전체',
        'location': '전체',
        'minPrice': 0.0,
        'maxPrice': 100000.0,
        'onlyAvailable': true,
        'sortBy': 'latest',
        'condition': 'all',
        'hasImages': false,
        'freeShipping': false,
        'instantRent': false,
      };
    });
    widget.onFiltersChanged(_currentFilters);
    widget.onReset?.call();
  }

  int _getActiveFiltersCount() {
    int count = 0;
    
    if (_currentFilters['category'] != '전체') count++;
    if (_currentFilters['location'] != '전체') count++;
    if (_currentFilters['minPrice'] != 0.0 || _currentFilters['maxPrice'] != 100000.0) count++;
    if (_currentFilters['onlyAvailable'] != true) count++;
    if (_currentFilters['sortBy'] != 'latest') count++;
    if (_currentFilters['condition'] != 'all') count++;
    if (_currentFilters['hasImages'] == true) count++;
    if (_currentFilters['freeShipping'] == true) count++;
    if (_currentFilters['instantRent'] == true) count++;
    
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          // 헤더
          _buildHeader(context),
          const Divider(height: 1),
          
          // 필터 내용
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCategoryFilter(),
                const SizedBox(height: 24),
                
                _buildLocationFilter(),
                const SizedBox(height: 24),
                
                _buildPriceRangeFilter(),
                const SizedBox(height: 24),
                
                _buildConditionFilter(),
                const SizedBox(height: 24),
                
                _buildAvailabilityFilter(),
                const SizedBox(height: 24),
                
                _buildFeatureFilters(),
                const SizedBox(height: 24),
                
                _buildSortingOptions(),
                
                const SizedBox(height: 80), // 하단 버튼 공간
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final activeCount = _getActiveFiltersCount();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '필터',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (activeCount > 0)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$activeCount',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: _resetFilters,
                child: Text(
                  '초기화',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TealButton(
                text: '적용하기',
                onPressed: () {
                  widget.onApply?.call();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return _buildFilterSection(
      '카테고리',
      Icons.category,
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _categories.map((category) {
          final isSelected = _currentFilters['category'] == category;
          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) => _updateFilter('category', category),
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLocationFilter() {
    return _buildFilterSection(
      '지역',
      Icons.location_on,
      Column(
        children: [
          // 현재 위치 사용 옵션
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.my_location,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '내 위치 주변에서 찾기',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Switch(
                  value: _currentFilters['useCurrentLocation'] ?? false,
                  onChanged: (value) => _updateFilter('useCurrentLocation', value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // 지역 선택
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _locations.map((location) {
              final isSelected = _currentFilters['location'] == location;
              return FilterChip(
                label: Text(location),
                selected: isSelected,
                onSelected: (selected) => _updateFilter('location', location),
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeFilter() {
    final minPrice = (_currentFilters['minPrice'] ?? 0.0).toDouble();
    final maxPrice = (_currentFilters['maxPrice'] ?? 100000.0).toDouble();
    
    return _buildFilterSection(
      '가격 범위',
      Icons.attach_money,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_formatPrice(minPrice.toInt())}원',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                '${_formatPrice(maxPrice.toInt())}원',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: RangeValues(minPrice, maxPrice),
            min: 0,
            max: 100000,
            divisions: 20,
            labels: RangeLabels(
              '${_formatPrice(minPrice.toInt())}원',
              '${_formatPrice(maxPrice.toInt())}원',
            ),
            onChanged: (values) {
              _updateFilter('minPrice', values.start);
              _updateFilter('maxPrice', values.end);
            },
          ),
          
          // 빠른 가격 선택
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickPriceChip(0, 10000, '1만원 이하'),
              _buildQuickPriceChip(10000, 30000, '1만원-3만원'),
              _buildQuickPriceChip(30000, 50000, '3만원-5만원'),
              _buildQuickPriceChip(50000, 100000, '5만원 이상'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPriceChip(double min, double max, String label) {
    final isSelected = _currentFilters['minPrice'] == min && _currentFilters['maxPrice'] == max;
    
    return ActionChip(
      label: Text(label),
      onPressed: () {
        _updateFilter('minPrice', min);
        _updateFilter('maxPrice', max);
      },
      backgroundColor: isSelected 
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceVariant,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildConditionFilter() {
    return _buildFilterSection(
      '상품 상태',
      Icons.star,
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _conditionOptions.map((option) {
          final isSelected = _currentFilters['condition'] == option['key'];
          return FilterChip(
            avatar: Icon(
              option['icon'] as IconData,
              size: 18,
              color: isSelected 
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            label: Text(option['label'] as String),
            selected: isSelected,
            onSelected: (selected) => _updateFilter('condition', option['key']),
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAvailabilityFilter() {
    return _buildFilterSection(
      '대여 가능성',
      Icons.check_circle,
      Column(
        children: [
          SwitchListTile(
            title: const Text('대여 가능한 상품만 보기'),
            subtitle: const Text('현재 대여 중인 상품 제외'),
            value: _currentFilters['onlyAvailable'] ?? true,
            onChanged: (value) => _updateFilter('onlyAvailable', value),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureFilters() {
    return _buildFilterSection(
      '특별 옵션',
      Icons.star_border,
      Column(
        children: [
          CheckboxListTile(
            title: const Text('사진 있는 상품만'),
            subtitle: const Text('상품 이미지가 있는 아이템만 표시'),
            value: _currentFilters['hasImages'] ?? false,
            onChanged: (value) => _updateFilter('hasImages', value),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text('무료 배송'),
            subtitle: const Text('배송비가 없는 상품만 표시'),
            value: _currentFilters['freeShipping'] ?? false,
            onChanged: (value) => _updateFilter('freeShipping', value),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text('즉시 대여 가능'),
            subtitle: const Text('바로 대여할 수 있는 상품만 표시'),
            value: _currentFilters['instantRent'] ?? false,
            onChanged: (value) => _updateFilter('instantRent', value),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  Widget _buildSortingOptions() {
    return _buildFilterSection(
      '정렬',
      Icons.sort,
      Column(
        children: _sortOptions.map((option) {
          return RadioListTile<String>(
            title: Text(option['label']!),
            value: option['key']!,
            groupValue: _currentFilters['sortBy'] ?? 'latest',
            onChanged: (value) => _updateFilter('sortBy', value),
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
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

// 필터 저장 프리셋 위젯
class FilterPresetsWidget extends StatelessWidget {
  final List<SearchFilterPreset> presets;
  final Function(SearchFilterPreset) onPresetSelected;
  final Function(String) onPresetSaved;
  final Function(String) onPresetDeleted;

  const FilterPresetsWidget({
    super.key,
    required this.presets,
    required this.onPresetSelected,
    required this.onPresetSaved,
    required this.onPresetDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '저장된 필터',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => _showSavePresetDialog(context),
                child: const Text('현재 필터 저장'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (presets.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '저장된 필터가 없습니다',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '자주 사용하는 필터 조합을 저장해보세요',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: presets.map((preset) => _buildPresetChip(context, preset)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(BuildContext context, SearchFilterPreset preset) {
    return ActionChip(
      label: Text(preset.name),
      avatar: preset.iconUrl != null 
          ? null 
          : const Icon(Icons.bookmark, size: 16),
      onPressed: () => onPresetSelected(preset),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: () => onPresetDeleted(preset.id),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showSavePresetDialog(BuildContext context) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('필터 저장'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: '필터 이름',
            hintText: '예: 카메라 3만원 이하',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                onPresetSaved(nameController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}