import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/simple_button.dart';
import '../../shared/widgets/teal_text_field.dart';

class SearchFilterScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  final String? initialCategory;

  const SearchFilterScreen({
    super.key,
    this.initialQuery,
    this.initialCategory,
  });

  @override
  ConsumerState<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedLocation;
  RangeValues _priceRange = const RangeValues(0, 100000);
  double _maxDistance = 5.0;
  String _sortBy = 'newest';
  bool _availableOnly = false;

  final List<String> _categories = [
    '카메라',
    '스포츠',
    '도구',
    '주방용품',
    '완구',
    '악기',
    '의류',
    '가전제품',
    '도서',
    '기타'
  ];

  final List<String> _locations = [
    '강남구',
    '서초구',
    '송파구',
    '마포구',
    '용산구',
    '성동구',
    '중구',
    '종로구'
  ];

  final List<Map<String, String>> _sortOptions = [
    {'value': 'newest', 'label': '최신순'},
    {'value': 'price_low', 'label': '가격 낮은 순'},
    {'value': 'price_high', 'label': '가격 높은 순'},
    {'value': 'rating', 'label': '평점 높은 순'},
    {'value': 'distance', 'label': '거리 가까운 순'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery ?? '';
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    // Apply filters and navigate back
    final filters = {
      'query': _searchController.text,
      'category': _selectedCategory,
      'location': _selectedLocation,
      'priceMin': _priceRange.start.round(),
      'priceMax': _priceRange.end.round(),
      'maxDistance': _maxDistance,
      'sortBy': _sortBy,
      'availableOnly': _availableOnly,
    };

    // In a real app, you would pass these filters to the search results
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('검색 필터가 적용되었습니다'),
        backgroundColor: Colors.green,
      ),
    );
    
    context.pop(filters);
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
      _selectedLocation = null;
      _priceRange = const RangeValues(0, 100000);
      _maxDistance = 5.0;
      _sortBy = 'newest';
      _availableOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색 및 필터'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('초기화'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search query
                  Text(
                    '검색어',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TealTextField(
                    controller: _searchController,
                    hintText: '찾고 싶은 물건을 입력하세요',
                    prefixIcon: Icons.search,
                  ),
                  const SizedBox(height: 32),

                  // Category filter
                  Text(
                    '카테고리',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('전체'),
                        selected: _selectedCategory == null,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = null;
                            });
                          }
                        },
                      ),
                      ..._categories.map((category) {
                        return FilterChip(
                          label: Text(category),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Location filter
                  Text(
                    '지역',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('전체'),
                        selected: _selectedLocation == null,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedLocation = null;
                            });
                          }
                        },
                      ),
                      ..._locations.map((location) {
                        return FilterChip(
                          label: Text(location),
                          selected: _selectedLocation == location,
                          onSelected: (selected) {
                            setState(() {
                              _selectedLocation = selected ? location : null;
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Price range
                  Text(
                    '가격 범위',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_priceRange.start.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원 - ${_priceRange.end.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                    style: TextStyle(
                      color: const Color(0xFF5CBDBD),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 100000,
                    divisions: 20,
                    activeColor: const Color(0xFF5CBDBD),
                    inactiveColor: const Color(0xFF5CBDBD).withOpacity(0.3),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  // Distance range
                  Text(
                    '거리 범위',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_maxDistance.toStringAsFixed(1)}km 이내',
                    style: TextStyle(
                      color: const Color(0xFF5CBDBD),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Slider(
                    value: _maxDistance,
                    min: 0.5,
                    max: 20.0,
                    divisions: 39,
                    activeColor: const Color(0xFF5CBDBD),
                    inactiveColor: const Color(0xFF5CBDBD).withOpacity(0.3),
                    onChanged: (value) {
                      setState(() {
                        _maxDistance = value;
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  // Sort options
                  Text(
                    '정렬 방식',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _sortOptions.map((option) {
                      return ChoiceChip(
                        label: Text(option['label']!),
                        selected: _sortBy == option['value'],
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _sortBy = option['value']!;
                            });
                          }
                        },
                        selectedColor: const Color(0xFF5CBDBD).withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: _sortBy == option['value'] 
                              ? const Color(0xFF5CBDBD)
                              : null,
                          fontWeight: _sortBy == option['value'] 
                              ? FontWeight.w600 
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Additional filters
                  Text(
                    '추가 옵션',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('대여 가능한 물건만 보기'),
                    value: _availableOnly,
                    onChanged: (value) {
                      setState(() {
                        _availableOnly = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFF5CBDBD),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 32),

                  // Filter summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5CBDBD).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '선택된 필터',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5CBDBD),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_searchController.text.isNotEmpty)
                          Text('• 검색어: ${_searchController.text}'),
                        if (_selectedCategory != null)
                          Text('• 카테고리: $_selectedCategory'),
                        if (_selectedLocation != null)
                          Text('• 지역: $_selectedLocation'),
                        Text('• 가격: ${_priceRange.start.round()}원 - ${_priceRange.end.round()}원'),
                        Text('• 거리: ${_maxDistance.toStringAsFixed(1)}km 이내'),
                        Text('• 정렬: ${_sortOptions.firstWhere((option) => option['value'] == _sortBy)['label']}'),
                        if (_availableOnly)
                          Text('• 대여 가능한 물건만'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: SimpleButton.outlined(
                    onPressed: () => context.pop(),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: SimpleButton.primary(
                    onPressed: _applyFilters,
                    child: const Text(
                      '검색하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}