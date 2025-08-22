import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/models/item_model.dart';
import '../../shared/widgets/teal_components.dart';
import '../../shared/widgets/cards/cards.dart';
import '../../shared/widgets/skeleton/skeleton_widgets.dart';
import '../../services/supabase_service.dart';
import '../../app/routes/app_routes.dart';

// New imports for enhanced search
import 'models/search_result.dart';
import 'models/search_suggestion.dart' as suggestion_model;
import 'services/search_service.dart';
import 'services/search_suggestions_service.dart';
import 'services/search_analytics_service.dart';
import 'widgets/search_bar_enhanced.dart';
import 'widgets/search_suggestions.dart';
import 'widgets/search_filters_panel.dart';
import 'widgets/search_results_grid.dart';
import 'widgets/empty_search_state.dart';

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
  
  // Enhanced search state
  SearchResult? _searchResult;
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  String _lastQuery = '';
  Timer? _debounceTimer;
  
  // UI state
  SearchResultsViewMode _viewMode = SearchResultsViewMode.grid;
  bool _showSuggestions = false;
  
  // 필터 상태 (Enhanced)
  Map<String, dynamic> _currentFilters = {
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


  @override
  void initState() {
    super.initState();
    
    // Set initial values
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _lastQuery = widget.initialQuery!;
    }
    if (widget.initialCategory != null) {
      _currentFilters['category'] = widget.initialCategory!;
    }
    
    _scrollController.addListener(_onScroll);
    
    // Perform initial search if needed
    if (widget.initialQuery != null || widget.initialCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSearch();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadMoreItems();
      }
    }
  }

  // Enhanced search methods
  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (query.trim() != _lastQuery.trim()) {
        _performSearch(query: query);
      }
    });
  }
  
  void _onSuggestionSelected(suggestion_model.SearchSuggestion suggestion) {
    _searchController.text = suggestion.text;
    _performSearch(query: suggestion.text);
    
    // Track suggestion click
    final analyticsService = ref.read(searchAnalyticsServiceProvider);
    analyticsService.trackSearch(
      query: suggestion.text,
      source: 'suggestion',
    );
  }

  Future<void> _performSearch({String? query}) async {
    final searchQuery = query ?? _searchController.text.trim();
    
    if (searchQuery == _lastQuery && _currentPage == 0) return;
    
    setState(() {
      _isLoading = true;
      if (searchQuery != _lastQuery) {
        _currentPage = 0;
        _searchResult = null;
        _hasMore = true;
        _lastQuery = searchQuery;
      }
    });

    try {
      final searchService = ref.read(searchServiceProvider);
      final result = await searchService.performSearch(
        searchQuery,
        filters: _currentFilters,
        page: _currentPage,
      );

      setState(() {
        if (_currentPage == 0) {
          _searchResult = result;
        } else {
          // Append to existing results
          _searchResult = SearchResult(
            items: [..._searchResult!.items, ...result.items],
            metadata: result.metadata,
            suggestions: result.suggestions,
            facets: result.facets,
            pagination: result.pagination,
          );
        }
        _hasMore = result.items.length >= 20;
        _isLoading = false;
      });
      
      // Track successful search
      final analyticsService = ref.read(searchAnalyticsServiceProvider);
      analyticsService.trackSearch(
        query: searchQuery,
        resultsCount: result.items.length,
        filters: _currentFilters,
      );
      
      // Save to search history
      if (searchQuery.isNotEmpty) {
        ref.read(searchHistoryProvider.notifier).addToHistory(
          suggestion_model.SearchHistory(
            query: searchQuery,
            timestamp: DateTime.now(),
            category: _currentFilters['category'] != '전체' ? _currentFilters['category'] : null,
            location: _currentFilters['location'] != '전체' ? _currentFilters['location'] : null,
            filters: _currentFilters,
          ),
        );
      }
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('검색 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading || !_hasMore) return;
    
    setState(() {
      _currentPage++;
    });

    await _performSearch();
  }

  void _onFiltersChanged(Map<String, dynamic> newFilters) {
    setState(() {
      _currentFilters = Map.from(newFilters);
    });
    
    // Trigger search with new filters
    if (_lastQuery.isNotEmpty) {
      _performSearch();
    }
  }
  
  void _onViewModeChanged(SearchResultsViewMode newMode) {
    setState(() {
      _viewMode = newMode;
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: EnhancedSearchBar(
          initialValue: _searchController.text,
          hintText: '찾고 있는 물건을 검색해보세요',
          onSubmitted: (query) => _performSearch(query: query),
          onChanged: _onSearchChanged,
          onSuggestionSelected: _onSuggestionSelected,
          showSuggestions: true,
          autofocus: widget.initialQuery?.isEmpty ?? true,
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.tune),
                if (_hasActiveFilters())
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${_getActiveFiltersCount()}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showFilterBottomSheet,
            tooltip: '필터',
          ),
        ],
      ),
      body: Column(
        children: [
          // Active filters chips
          if (_hasActiveFilters()) _buildActiveFilters(),
          
          // Main content
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return _currentFilters['category'] != '전체' ||
           _currentFilters['location'] != '전체' ||
           _currentFilters['minPrice'] > 0 ||
           _currentFilters['maxPrice'] < 100000 ||
           _currentFilters['onlyAvailable'] != true ||
           _currentFilters['sortBy'] != 'latest' ||
           _currentFilters['condition'] != 'all' ||
           _currentFilters['hasImages'] == true ||
           _currentFilters['freeShipping'] == true ||
           _currentFilters['instantRent'] == true;
  }
  
  int _getActiveFiltersCount() {
    int count = 0;
    if (_currentFilters['category'] != '전체') count++;
    if (_currentFilters['location'] != '전체') count++;
    if (_currentFilters['minPrice'] > 0 || _currentFilters['maxPrice'] < 100000) count++;
    if (_currentFilters['onlyAvailable'] != true) count++;
    if (_currentFilters['sortBy'] != 'latest') count++;
    if (_currentFilters['condition'] != 'all') count++;
    if (_currentFilters['hasImages'] == true) count++;
    if (_currentFilters['freeShipping'] == true) count++;
    if (_currentFilters['instantRent'] == true) count++;
    return count;
  }

  Widget _buildMainContent() {
    if (_searchController.text.trim().isEmpty) {
      return EmptySearchState(
        onSearchTap: (query) {
          _searchController.text = query;
          _performSearch(query: query);
        },
        onCategoryTap: (category) {
          setState(() {
            _currentFilters['category'] = category;
          });
          _performSearch();
        },
        onRecentSearchRemove: (query) {
          ref.read(searchHistoryProvider.notifier).removeFromHistory(query);
        },
      );
    }
    
    if (_searchResult == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return SearchResultsGrid(
      searchResult: _searchResult!,
      isLoading: _isLoading,
      hasMore: _hasMore,
      onLoadMore: _loadMoreItems,
      viewMode: _viewMode,
      onViewModeChanged: _onViewModeChanged,
      searchQuery: _lastQuery,
    );
  }
  
  Widget _buildActiveFilters() {
    final activeFilters = <Widget>[];
    
    if (_currentFilters['category'] != '전체') {
      activeFilters.add(TealChip(
        label: _currentFilters['category'],
        onDeleted: () {
          _currentFilters['category'] = '전체';
          _onFiltersChanged(_currentFilters);
        },
      ));
    }
    
    if (_currentFilters['location'] != '전체') {
      activeFilters.add(TealChip(
        label: _currentFilters['location'],
        onDeleted: () {
          _currentFilters['location'] = '전체';
          _onFiltersChanged(_currentFilters);
        },
      ));
    }
    
    final minPrice = _currentFilters['minPrice'] as double;
    final maxPrice = _currentFilters['maxPrice'] as double;
    if (minPrice > 0 || maxPrice < 100000) {
      activeFilters.add(TealChip(
        label: '${_formatPrice(minPrice.toInt())} - ${_formatPrice(maxPrice.toInt())}원',
        onDeleted: () {
          _currentFilters['minPrice'] = 0.0;
          _currentFilters['maxPrice'] = 100000.0;
          _onFiltersChanged(_currentFilters);
        },
      ));
    }
    
    if (_currentFilters['onlyAvailable'] != true) {
      activeFilters.add(TealChip(
        label: '대여중 포함',
        onDeleted: () {
          _currentFilters['onlyAvailable'] = true;
          _onFiltersChanged(_currentFilters);
        },
      ));
    }
    
    if (_currentFilters['condition'] != 'all') {
      final conditionLabels = {
        'new': '새상품',
        'like_new': '거의 새것',
        'good': '좋음',
        'fair': '보통',
      };
      activeFilters.add(TealChip(
        label: conditionLabels[_currentFilters['condition']] ?? _currentFilters['condition'],
        onDeleted: () {
          _currentFilters['condition'] = 'all';
          _onFiltersChanged(_currentFilters);
        },
      ));
    }
    
    if (activeFilters.isEmpty) return const SizedBox.shrink();
    
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...activeFilters.map((chip) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: chip,
          )),
          // Clear all filters button
          ActionChip(
            label: const Text('전체 삭제'),
            avatar: const Icon(Icons.clear_all, size: 16),
            onPressed: () {
              _resetFilters();
              _onFiltersChanged(_currentFilters);
            },
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
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SearchFiltersPanel(
          initialFilters: _currentFilters,
          onFiltersChanged: _onFiltersChanged,
          onReset: _resetFilters,
          onApply: () => _performSearch(),
        ),
      ),
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