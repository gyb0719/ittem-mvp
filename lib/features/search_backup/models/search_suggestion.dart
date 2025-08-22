import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_suggestion.freezed.dart';
part 'search_suggestion.g.dart';

@freezed
class SearchSuggestion with _$SearchSuggestion {
  const factory SearchSuggestion({
    required String text,
    required SearchSuggestionType type,
    String? category,
    String? imageUrl,
    @Default(0) int resultsCount,
    @Default(0.0) double relevanceScore,
    Map<String, dynamic>? metadata,
  }) = _SearchSuggestion;

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionFromJson(json);
}

enum SearchSuggestionType {
  @JsonValue('query')
  query,        // 검색어 제안
  @JsonValue('category')
  category,     // 카테고리 제안
  @JsonValue('brand')
  brand,        // 브랜드 제안
  @JsonValue('location')
  location,     // 위치 제안
  @JsonValue('recent')
  recent,       // 최근 검색어
  @JsonValue('popular')
  popular,      // 인기 검색어
  @JsonValue('autocomplete')
  autocomplete, // 자동완성
}

@freezed
class SearchHistory with _$SearchHistory {
  const factory SearchHistory({
    required String query,
    required DateTime timestamp,
    String? category,
    String? location,
    @Default(1) int searchCount,
    Map<String, dynamic>? filters,
  }) = _SearchHistory;

  factory SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryFromJson(json);
}

@freezed
class PopularSearch with _$PopularSearch {
  const factory PopularSearch({
    required String query,
    required int searchCount,
    required double trendingScore,
    String? category,
    DateTime? lastSearched,
  }) = _PopularSearch;

  factory PopularSearch.fromJson(Map<String, dynamic> json) =>
      _$PopularSearchFromJson(json);
}