import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/item_model.dart';
import '../../../services/supabase_service.dart';
import '../models/search_result.dart';
import '../models/search_suggestion.dart' as suggestion_model;
import '../models/search_filter.dart';

final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService(ref.read(supabaseServiceProvider));
});

class SearchService {
  final SupabaseService _supabaseService;
  final Map<String, SearchResult> _searchCache = {};
  final List<suggestion_model.SearchHistory> _searchHistory = [];
  
  SearchService(this._supabaseService);

  // 디바운스된 검색
  Timer? _debounceTimer;
  StreamController<SearchResult>? _searchResultController;

  Stream<SearchResult> searchWithDebounce(String query, {
    Map<String, dynamic>? filters,
    String sortBy = 'relevance',
    Duration debounceDelay = const Duration(milliseconds: 300),
  }) {
    _searchResultController?.close();
    _searchResultController = StreamController<SearchResult>();
    
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDelay, () async {
      try {
        final result = await performSearch(
          query,
          filters: filters,
          sortBy: sortBy,
        );
        _searchResultController?.add(result);
      } catch (e) {
        _searchResultController?.addError(e);
      }
    });
    
    return _searchResultController!.stream;
  }

  // 메인 검색 함수
  Future<SearchResult> performSearch(
    String query, {
    Map<String, dynamic>? filters,
    String sortBy = 'relevance',
    int page = 0,
    int limit = 20,
  }) async {
    final cacheKey = _generateCacheKey(query, filters, sortBy, page, limit);
    
    // 캐시 확인
    if (_searchCache.containsKey(cacheKey)) {
      return _searchCache[cacheKey]!;
    }

    final stopwatch = Stopwatch()..start();
    
    try {
      // 검색어 교정 및 정규화
      final normalizedQuery = _normalizeQuery(query);
      final correctedQuery = await _getSpellCorrection(normalizedQuery);
      
      // 검색 실행
      final items = await _executeSearch(
        correctedQuery.isNotEmpty ? correctedQuery : normalizedQuery,
        filters: filters,
        sortBy: sortBy,
        offset: page * limit,
        limit: limit,
      );

      // 개인화된 정렬 적용
      final personalizedItems = await _applyPersonalization(items, query);
      
      // 검색 결과 생성
      final result = SearchResult(
        items: personalizedItems,
        metadata: SearchMetadata(
          totalCount: personalizedItems.length, // TODO: 실제 총 개수
          searchTime: stopwatch.elapsedMilliseconds,
          query: query,
          appliedFilters: filters,
          sortBy: sortBy,
          correctedQuery: correctedQuery.isNotEmpty ? correctedQuery : null,
          hasSpellCorrection: correctedQuery.isNotEmpty,
          searchTerms: _extractSearchTerms(normalizedQuery),
        ),
        suggestions: await _getSearchSuggestions(query),
        facets: await _generateFacets(personalizedItems),
      );

      // 캐시 저장 (최대 100개)
      if (_searchCache.length >= 100) {
        _searchCache.remove(_searchCache.keys.first);
      }
      _searchCache[cacheKey] = result;
      
      // 검색 히스토리 저장
      _addToSearchHistory(query, filters);
      
      return result;
    } finally {
      stopwatch.stop();
    }
  }

  // 실시간 검색 제안
  Future<List<suggestion_model.SearchSuggestion>> getSuggestions(String query) async {
    if (query.trim().isEmpty) {
      return _getEmptyStateSuggestions();
    }

    final suggestions = <suggestion_model.SearchSuggestion>[];
    
    // 1. 자동완성 제안
    final autocompleteSuggestions = await _getAutocompleteSuggestions(query);
    suggestions.addAll(autocompleteSuggestions);
    
    // 2. 카테고리 제안
    final categorySuggestions = await _getCategorySuggestions(query);
    suggestions.addAll(categorySuggestions);
    
    // 3. 최근 검색어에서 매칭
    final recentMatches = _getRecentSearchMatches(query);
    suggestions.addAll(recentMatches);
    
    // 4. 인기 검색어에서 매칭
    final popularMatches = await _getPopularSearchMatches(query);
    suggestions.addAll(popularMatches);
    
    // 유사도 점수로 정렬하고 최대 10개 반환
    suggestions.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    return suggestions.take(10).toList();
  }

  // 검색 히스토리 관리
  List<suggestion_model.SearchHistory> getSearchHistory() {
    return List.from(_searchHistory);
  }

  void clearSearchHistory() {
    _searchHistory.clear();
  }

  void removeFromSearchHistory(String query) {
    _searchHistory.removeWhere((history) => history.query == query);
  }

  // 인기 검색어 가져오기
  Future<List<suggestion_model.PopularSearch>> getPopularSearches({int limit = 10}) async {
    // TODO: 실제로는 서버에서 분석된 인기 검색어를 가져와야 함
    return [
      suggestion_model.PopularSearch(
        query: 'DSLR 카메라',
        searchCount: 1250,
        trendingScore: 8.5,
        category: '카메라',
      ),
      suggestion_model.PopularSearch(
        query: '텐트',
        searchCount: 980,
        trendingScore: 7.8,
        category: '스포츠',
      ),
      suggestion_model.PopularSearch(
        query: '아기용품',
        searchCount: 756,
        trendingScore: 7.2,
        category: '완구',
      ),
      suggestion_model.PopularSearch(
        query: 'MacBook',
        searchCount: 654,
        trendingScore: 6.9,
        category: '가전제품',
      ),
    ];
  }

  // Private methods

  String _generateCacheKey(String query, Map<String, dynamic>? filters, 
      String sortBy, int page, int limit) {
    return '$query|${filters?.toString() ?? ''}|$sortBy|$page|$limit';
  }

  String _normalizeQuery(String query) {
    // 한영 변환, 공백 정리, 특수문자 처리 등
    return query.trim().toLowerCase();
  }

  Future<String> _getSpellCorrection(String query) async {
    // TODO: 실제 맞춤법 검사 API 연동
    // 지금은 간단한 오타 교정만
    final corrections = {
      'dslr': 'DSLR',
      'macbook': 'MacBook',
      'iphone': 'iPhone',
    };
    
    String corrected = query;
    corrections.forEach((wrong, correct) {
      corrected = corrected.replaceAll(wrong, correct);
    });
    
    return corrected != query ? corrected : '';
  }

  Future<List<ItemModel>> _executeSearch(
    String query, {
    Map<String, dynamic>? filters,
    String sortBy = 'relevance',
    int offset = 0,
    int limit = 20,
  }) async {
    return await _supabaseService.searchItems(
      query: query,
      category: filters?['category'],
      location: filters?['location'],
      minPrice: filters?['minPrice']?.toDouble(),
      maxPrice: filters?['maxPrice']?.toDouble(),
      onlyAvailable: filters?['onlyAvailable'] ?? true,
      sortBy: sortBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<List<ItemModel>> _applyPersonalization(List<ItemModel> items, String query) async {
    // TODO: 사용자 선호도, 위치, 과거 검색 기록을 기반으로 개인화
    // 지금은 기본 정렬만 적용
    return items;
  }

  List<String> _extractSearchTerms(String query) {
    return query.split(' ').where((term) => term.isNotEmpty).toList();
  }

  Future<List<suggestion_model.SearchSuggestion>> _getSearchSuggestions(String query) async {
    // 검색 결과 기반 추가 제안
    return [];
  }

  Future<List<SearchFacet>> _generateFacets(List<ItemModel> items) async {
    // 검색 결과를 기반으로 필터링 가능한 패싯 생성
    final facets = <SearchFacet>[];
    
    // 카테고리 패싯
    final categoryMap = <String, int>{};
    for (final item in items) {
      categoryMap[item.category] = (categoryMap[item.category] ?? 0) + 1;
    }
    
    if (categoryMap.isNotEmpty) {
      facets.add(SearchFacet(
        name: 'category',
        displayName: '카테고리',
        values: categoryMap.entries
            .map((e) => SearchFacetValue(
                  value: e.key,
                  displayValue: e.key,
                  count: e.value,
                ))
            .toList()
          ..sort((a, b) => b.count.compareTo(a.count)),
      ));
    }
    
    return facets;
  }

  void _addToSearchHistory(String query, Map<String, dynamic>? filters) {
    // 중복 제거
    _searchHistory.removeWhere((history) => history.query == query);
    
    // 새로운 검색 기록 추가
    _searchHistory.insert(0, suggestion_model.SearchHistory(
      query: query,
      timestamp: DateTime.now(),
      category: filters?['category'],
      location: filters?['location'],
      filters: filters,
    ));
    
    // 최대 50개 유지
    if (_searchHistory.length > 50) {
      _searchHistory.removeLast();
    }
  }

  Future<List<suggestion_model.SearchSuggestion>> _getEmptyStateSuggestions() async {
    final popular = await getPopularSearches(limit: 5);
    return popular.map((pop) => suggestion_model.SearchSuggestion(
      text: pop.query,
      type: suggestion_model.SearchSuggestionType.popular,
      category: pop.category,
      resultsCount: pop.searchCount,
      relevanceScore: pop.trendingScore,
    )).toList();
  }

  Future<List<suggestion_model.SearchSuggestion>> _getAutocompleteSuggestions(String query) async {
    // TODO: 실제 자동완성 API 연동
    final suggestions = <String>[];
    
    // 간단한 키워드 매칭
    final keywords = [
      'DSLR 카메라', '미러리스 카메라', '렌즈', '삼각대',
      '텐트', '침낭', '백팩', '등산화',
      'MacBook', 'iPad', 'iPhone', '무선이어폰',
      '아기침대', '유모차', '카시트', '장난감',
    ];
    
    for (final keyword in keywords) {
      if (keyword.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(keyword);
      }
    }
    
    return suggestions.map((text) => suggestion_model.SearchSuggestion(
      text: text,
      type: suggestion_model.SearchSuggestionType.autocomplete,
      relevanceScore: _calculateRelevanceScore(query, text),
    )).toList();
  }

  Future<List<suggestion_model.SearchSuggestion>> _getCategorySuggestions(String query) async {
    final categories = [
      '카메라', '스포츠', '도구', '주방용품', '완구', '악기', '의류', '가전제품', '도서', '기타'
    ];
    
    final suggestions = <suggestion_model.SearchSuggestion>[];
    for (final category in categories) {
      if (category.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(suggestion_model.SearchSuggestion(
          text: category,
          type: suggestion_model.SearchSuggestionType.category,
          category: category,
          relevanceScore: _calculateRelevanceScore(query, category),
        ));
      }
    }
    
    return suggestions;
  }

  List<suggestion_model.SearchSuggestion> _getRecentSearchMatches(String query) {
    return _searchHistory
        .where((history) => history.query.toLowerCase().contains(query.toLowerCase()))
        .take(3)
        .map((history) => suggestion_model.SearchSuggestion(
              text: history.query,
              type: suggestion_model.SearchSuggestionType.recent,
              category: history.category,
              relevanceScore: _calculateRelevanceScore(query, history.query),
            ))
        .toList();
  }

  Future<List<suggestion_model.SearchSuggestion>> _getPopularSearchMatches(String query) async {
    final popular = await getPopularSearches();
    return popular
        .where((pop) => pop.query.toLowerCase().contains(query.toLowerCase()))
        .take(3)
        .map((pop) => suggestion_model.SearchSuggestion(
              text: pop.query,
              type: suggestion_model.SearchSuggestionType.popular,
              category: pop.category,
              resultsCount: pop.searchCount,
              relevanceScore: _calculateRelevanceScore(query, pop.query) + 
                             (pop.trendingScore / 10), // 인기도 보너스
            ))
        .toList();
  }

  double _calculateRelevanceScore(String query, String candidate) {
    if (candidate.toLowerCase() == query.toLowerCase()) return 10.0;
    if (candidate.toLowerCase().startsWith(query.toLowerCase())) return 8.0;
    if (candidate.toLowerCase().contains(query.toLowerCase())) return 6.0;
    
    // 레벤슈타인 거리 계산 (간단 버전)
    final distance = _levenshteinDistance(query.toLowerCase(), candidate.toLowerCase());
    final maxLength = max(query.length, candidate.length);
    return max(0, 5.0 - (distance / maxLength * 5));
  }

  int _levenshteinDistance(String s1, String s2) {
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;
    
    final matrix = List.generate(
      s1.length + 1,
      (i) => List.filled(s2.length + 1, 0),
    );
    
    for (int i = 0; i <= s1.length; i++) matrix[i][0] = i;
    for (int j = 0; j <= s2.length; j++) matrix[0][j] = j;
    
    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,     // deletion
          matrix[i][j - 1] + 1,     // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    
    return matrix[s1.length][s2.length];
  }

  void dispose() {
    _debounceTimer?.cancel();
    _searchResultController?.close();
  }
}