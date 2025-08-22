import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService();
});

class SearchService {
  static const String _searchHistoryKey = 'search_history';
  static const String _searchFiltersKey = 'search_filters';
  static const int maxHistoryItems = 20;

  // 검색 기록 관리
  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_searchHistoryKey) ?? [];
    return historyJson;
  }

  Future<void> addSearchHistory(String query) async {
    if (query.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();
    
    // 중복 제거
    history.remove(query);
    // 맨 앞에 추가
    history.insert(0, query);
    
    // 최대 개수 제한
    if (history.length > maxHistoryItems) {
      history.removeRange(maxHistoryItems, history.length);
    }
    
    await prefs.setStringList(_searchHistoryKey, history);
  }

  Future<void> removeSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();
    history.remove(query);
    await prefs.setStringList(_searchHistoryKey, history);
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
  }

  // 검색 필터 저장/불러오기
  Future<SearchFilters> getSavedFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final filtersJson = prefs.getString(_searchFiltersKey);
    
    if (filtersJson != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(filtersJson);
        return SearchFilters.fromJson(data);
      } catch (e) {
        // JSON 파싱 실패 시 기본값 반환
        return SearchFilters.defaultFilters();
      }
    }
    
    return SearchFilters.defaultFilters();
  }

  Future<void> saveFilters(SearchFilters filters) async {
    final prefs = await SharedPreferences.getInstance();
    final filtersJson = jsonEncode(filters.toJson());
    await prefs.setString(_searchFiltersKey, filtersJson);
  }

  // 검색 제안어 생성
  List<String> getSearchSuggestions(String query, List<String> history) {
    if (query.isEmpty) return [];
    
    final suggestions = <String>[];
    final queryLower = query.toLowerCase();
    
    // 기록에서 검색
    for (final item in history) {
      if (item.toLowerCase().contains(queryLower)) {
        suggestions.add(item);
      }
    }
    
    // 인기 검색어 (하드코딩된 예시)
    final popularSearches = [
      'DSLR 카메라', '맥북', '아이패드', '텐트', '캠핑용품', 
      '스피커', '헤드폰', '자전거', '운동기구', '책상',
      '의자', '냉장고', '세탁기', '에어컨', '청소기'
    ];
    
    for (final item in popularSearches) {
      if (item.toLowerCase().contains(queryLower) && !suggestions.contains(item)) {
        suggestions.add(item);
      }
    }
    
    return suggestions.take(5).toList();
  }

  // 카테고리별 인기 검색어
  Map<String, List<String>> getPopularByCategory() {
    return {
      '카메라': ['DSLR', '미러리스', '렌즈', '삼각대', '플래시'],
      '스포츠': ['헬스기구', '자전거', '골프용품', '축구공', '농구공'],
      '도구': ['드릴', '전동공구', '망치', '드라이버', '렌치'],
      '주방용품': ['믹서기', '전자레인지', '에어프라이어', '커피머신', '토스터'],
      '완구': ['레고', '보드게임', '인형', '장난감자동차', '퍼즐'],
      '악기': ['기타', '피아노', '우클렐레', '바이올린', '드럼'],
      '의류': ['정장', '원피스', '코트', '신발', '가방'],
      '가전제품': ['TV', '냉장고', '세탁기', '에어컨', '청소기'],
      '도서': ['소설', '자기계발', '요리책', '여행서', '만화책'],
    };
  }
}

class SearchFilters {
  final String category;
  final String location;
  final double minPrice;
  final double maxPrice;
  final String sortBy;
  final bool onlyAvailable;
  final double maxDistance; // km

  const SearchFilters({
    required this.category,
    required this.location,
    required this.minPrice,
    required this.maxPrice,
    required this.sortBy,
    required this.onlyAvailable,
    required this.maxDistance,
  });

  factory SearchFilters.defaultFilters() {
    return const SearchFilters(
      category: '전체',
      location: '전체',
      minPrice: 0,
      maxPrice: 100000,
      sortBy: 'latest',
      onlyAvailable: true,
      maxDistance: 10.0,
    );
  }

  factory SearchFilters.fromJson(Map<String, dynamic> json) {
    return SearchFilters(
      category: json['category'] ?? '전체',
      location: json['location'] ?? '전체',
      minPrice: (json['minPrice'] ?? 0).toDouble(),
      maxPrice: (json['maxPrice'] ?? 100000).toDouble(),
      sortBy: json['sortBy'] ?? 'latest',
      onlyAvailable: json['onlyAvailable'] ?? true,
      maxDistance: (json['maxDistance'] ?? 10.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'location': location,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'sortBy': sortBy,
      'onlyAvailable': onlyAvailable,
      'maxDistance': maxDistance,
    };
  }

  SearchFilters copyWith({
    String? category,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool? onlyAvailable,
    double? maxDistance,
  }) {
    return SearchFilters(
      category: category ?? this.category,
      location: location ?? this.location,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
      maxDistance: maxDistance ?? this.maxDistance,
    );
  }

  bool get hasActiveFilters {
    return category != '전체' ||
           location != '전체' ||
           minPrice > 0 ||
           maxPrice < 100000 ||
           sortBy != 'latest' ||
           !onlyAvailable ||
           maxDistance < 10.0;
  }

  int get activeFilterCount {
    int count = 0;
    if (category != '전체') count++;
    if (location != '전체') count++;
    if (minPrice > 0 || maxPrice < 100000) count++;
    if (sortBy != 'latest') count++;
    if (!onlyAvailable) count++;
    if (maxDistance < 10.0) count++;
    return count;
  }
}