import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/search_suggestion.dart';
import 'search_service.dart';

final searchSuggestionsServiceProvider = Provider<SearchSuggestionsService>((ref) {
  return SearchSuggestionsService(ref.read(searchServiceProvider));
});

final searchSuggestionsProvider = StreamProvider.family<List<SearchSuggestion>, String>(
  (ref, query) {
    final service = ref.read(searchSuggestionsServiceProvider);
    return service.getSuggestionsStream(query);
  },
);

final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<SearchHistory>>(
  (ref) {
    return SearchHistoryNotifier();
  },
);

final popularSearchesProvider = FutureProvider<List<PopularSearch>>((ref) async {
  final service = ref.read(searchServiceProvider);
  return service.getPopularSearches();
});

class SearchSuggestionsService {
  final SearchService _searchService;
  final StreamController<List<SearchSuggestion>> _suggestionsController = 
      StreamController<List<SearchSuggestion>>.broadcast();
  
  Timer? _debounceTimer;
  String _lastQuery = '';
  
  SearchSuggestionsService(this._searchService);

  Stream<List<SearchSuggestion>> getSuggestionsStream(String query) {
    if (query != _lastQuery) {
      _lastQuery = query;
      _debouncedGetSuggestions(query);
    }
    
    return _suggestionsController.stream;
  }

  void _debouncedGetSuggestions(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 200), () async {
      try {
        final suggestions = await _searchService.getSuggestions(query);
        _suggestionsController.add(suggestions);
      } catch (e) {
        _suggestionsController.addError(e);
      }
    });
  }

  // 즉시 제안 가져오기 (캐시된 결과)
  Future<List<SearchSuggestion>> getImmediateSuggestions(String query) async {
    return await _searchService.getSuggestions(query);
  }

  // 검색어 자동완성 (더 빠른 응답)
  Future<List<String>> getQuickAutocompletions(String query) async {
    if (query.trim().isEmpty) return [];
    
    // 로컬 캐시에서 빠른 자동완성
    final quickSuggestions = <String>[];
    
    // 간단한 키워드 매칭
    final keywords = [
      'DSLR', 'DSLR 카메라', '미러리스', '미러리스 카메라',
      '텐트', '캠핑', '캠핑용품', '등산', '등산용품',
      'MacBook', 'iPad', 'iPhone', '노트북', '태블릿',
      '아기용품', '유모차', '카시트', '장난감',
    ];
    
    for (final keyword in keywords) {
      if (keyword.toLowerCase().contains(query.toLowerCase())) {
        quickSuggestions.add(keyword);
      }
    }
    
    return quickSuggestions.take(5).toList();
  }

  // 트렌딩 검색어 (실시간 인기 검색어)
  Future<List<String>> getTrendingSearches() async {
    // TODO: 실제로는 서버에서 실시간 트렌딩 데이터를 가져와야 함
    return [
      'DSLR 카메라',
      '겨울 텐트',
      '무선이어폰',
      '아기용품',
      'MacBook Pro',
      '공기청정기',
      '게이밍 의자',
    ];
  }

  // 사용자 맞춤 검색어 제안
  Future<List<String>> getPersonalizedSuggestions(String query) async {
    // TODO: 사용자의 검색 패턴, 관심 카테고리 등을 분석하여 개인화된 제안
    final history = _searchService.getSearchHistory();
    final personalizedSuggestions = <String>[];
    
    // 사용자가 자주 검색한 카테고리에서 관련 키워드 제안
    final frequentCategories = _getFrequentCategories(history);
    
    for (final category in frequentCategories.take(3)) {
      final categorySuggestions = await _getCategoryKeywords(category, query);
      personalizedSuggestions.addAll(categorySuggestions);
    }
    
    return personalizedSuggestions.take(3).toList();
  }

  // 위치 기반 검색 제안
  Future<List<String>> getLocationBasedSuggestions(String query, String? userLocation) async {
    if (userLocation == null) return [];
    
    // TODO: 사용자 위치 기반으로 해당 지역에서 인기있는 검색어 제안
    final locationSuggestions = <String>[];
    
    // 지역별 인기 키워드 (예시)
    final locationKeywords = {
      '강남구': ['명품', '고급', '프리미엄'],
      '홍대': ['악기', '음향장비', '파티용품'],
      '성동구': ['공구', '전동공구', 'DIY'],
    };
    
    final keywords = locationKeywords[userLocation] ?? [];
    for (final keyword in keywords) {
      if (keyword.contains(query) || query.contains(keyword)) {
        locationSuggestions.add('$query $keyword');
      }
    }
    
    return locationSuggestions;
  }

  // 검색 제안 품질 향상을 위한 분석
  Future<void> trackSuggestionClick(SearchSuggestion suggestion) async {
    // TODO: 제안 클릭 추적하여 제안 품질 개선
  }

  Future<void> trackSuggestionShown(List<SearchSuggestion> suggestions) async {
    // TODO: 표시된 제안들 추적하여 노출 통계 수집
  }

  List<String> _getFrequentCategories(List<SearchHistory> history) {
    final categoryCount = <String, int>{};
    
    for (final search in history) {
      if (search.category != null) {
        categoryCount[search.category!] = 
            (categoryCount[search.category!] ?? 0) + 1;
      }
    }
    
    final sortedCategories = categoryCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedCategories.map((e) => e.key).toList();
  }

  Future<List<String>> _getCategoryKeywords(String category, String query) async {
    // 카테고리별 관련 키워드 맵
    final categoryKeywords = {
      '카메라': ['DSLR', '미러리스', '렌즈', '삼각대', '플래시'],
      '스포츠': ['등산', '캠핑', '텐트', '침낭', '배낭'],
      '가전제품': ['노트북', '태블릿', '스마트폰', '이어폰', '충전기'],
      '완구': ['레고', '인형', '보드게임', '퍼즐', '장난감'],
    };
    
    final keywords = categoryKeywords[category] ?? [];
    return keywords
        .where((keyword) => 
            keyword.toLowerCase().contains(query.toLowerCase()) ||
            query.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  void dispose() {
    _debounceTimer?.cancel();
    _suggestionsController.close();
  }
}

class SearchHistoryNotifier extends StateNotifier<List<SearchHistory>> {
  static const String _storageKey = 'search_history';
  
  SearchHistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_storageKey) ?? [];
      
      final history = historyJson
          .map((json) => SearchHistory.fromJson(
              Map<String, dynamic>.from(
                  // JSON 파싱 로직 (실제로는 더 안전한 파싱 필요)
                  <String, dynamic>{})))
          .toList();
      
      state = history;
    } catch (e) {
      // 로딩 실패 시 빈 리스트 유지
      state = [];
    }
  }

  Future<void> addToHistory(SearchHistory searchHistory) async {
    // 중복 제거
    final newState = state.where((h) => h.query != searchHistory.query).toList();
    
    // 새로운 검색 기록을 맨 앞에 추가
    newState.insert(0, searchHistory);
    
    // 최대 50개 유지
    if (newState.length > 50) {
      newState.removeLast();
    }
    
    state = newState;
    await _saveHistory();
  }

  Future<void> removeFromHistory(String query) async {
    state = state.where((h) => h.query != query).toList();
    await _saveHistory();
  }

  Future<void> clearHistory() async {
    state = [];
    await _saveHistory();
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = state
          .map((history) => history.toJson())
          .map((json) => json.toString()) // 실제로는 proper JSON encoding 필요
          .toList();
      
      await prefs.setStringList(_storageKey, historyJson);
    } catch (e) {
      // 저장 실패 시 무시 (로그 기록은 필요)
    }
  }
}