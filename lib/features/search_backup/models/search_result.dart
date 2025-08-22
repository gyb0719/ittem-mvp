import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../shared/models/item_model.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required List<ItemModel> items,
    required SearchMetadata metadata,
    List<SearchSuggestion>? suggestions,
    List<SearchFacet>? facets,
    SearchPagination? pagination,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}

@freezed
class SearchMetadata with _$SearchMetadata {
  const factory SearchMetadata({
    required int totalCount,
    required int searchTime, // milliseconds
    required String query,
    Map<String, dynamic>? appliedFilters,
    String? sortBy,
    String? correctedQuery,
    @Default(false) bool hasSpellCorrection,
    List<String>? searchTerms,
  }) = _SearchMetadata;

  factory SearchMetadata.fromJson(Map<String, dynamic> json) =>
      _$SearchMetadataFromJson(json);
}

@freezed
class SearchSuggestion with _$SearchSuggestion {
  const factory SearchSuggestion({
    required String text,
    required String type,
    @Default(0) int resultsCount,
  }) = _SearchSuggestion;

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionFromJson(json);
}

@freezed
class SearchFacet with _$SearchFacet {
  const factory SearchFacet({
    required String name,
    required String displayName,
    required List<SearchFacetValue> values,
    @Default('single') String type, // single, multiple, range
  }) = _SearchFacet;

  factory SearchFacet.fromJson(Map<String, dynamic> json) =>
      _$SearchFacetFromJson(json);
}

@freezed
class SearchFacetValue with _$SearchFacetValue {
  const factory SearchFacetValue({
    required String value,
    required String displayValue,
    required int count,
    @Default(false) bool isSelected,
  }) = _SearchFacetValue;

  factory SearchFacetValue.fromJson(Map<String, dynamic> json) =>
      _$SearchFacetValueFromJson(json);
}

@freezed
class SearchPagination with _$SearchPagination {
  const factory SearchPagination({
    required int currentPage,
    required int totalPages,
    required int pageSize,
    required bool hasNext,
    required bool hasPrevious,
  }) = _SearchPagination;

  factory SearchPagination.fromJson(Map<String, dynamic> json) =>
      _$SearchPaginationFromJson(json);
}

@freezed
class SearchAnalytics with _$SearchAnalytics {
  const factory SearchAnalytics({
    required String sessionId,
    required String query,
    required DateTime timestamp,
    int? resultsCount,
    int? clickPosition,
    String? clickedItemId,
    String? refinedQuery,
    Map<String, dynamic>? filters,
    int? searchDuration,
    String? source, // voice, text, barcode, image
  }) = _SearchAnalytics;

  factory SearchAnalytics.fromJson(Map<String, dynamic> json) =>
      _$SearchAnalyticsFromJson(json);
}