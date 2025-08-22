// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchResultImpl _$$SearchResultImplFromJson(
  Map<String, dynamic> json,
) => _$SearchResultImpl(
  items: (json['items'] as List<dynamic>)
      .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  metadata: SearchMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  suggestions: (json['suggestions'] as List<dynamic>?)
      ?.map((e) => SearchSuggestion.fromJson(e as Map<String, dynamic>))
      .toList(),
  facets: (json['facets'] as List<dynamic>?)
      ?.map((e) => SearchFacet.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: json['pagination'] == null
      ? null
      : SearchPagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$SearchResultImplToJson(_$SearchResultImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'metadata': instance.metadata,
      'suggestions': instance.suggestions,
      'facets': instance.facets,
      'pagination': instance.pagination,
    };

_$SearchMetadataImpl _$$SearchMetadataImplFromJson(Map<String, dynamic> json) =>
    _$SearchMetadataImpl(
      totalCount: (json['totalCount'] as num).toInt(),
      searchTime: (json['searchTime'] as num).toInt(),
      query: json['query'] as String,
      appliedFilters: json['appliedFilters'] as Map<String, dynamic>?,
      sortBy: json['sortBy'] as String?,
      correctedQuery: json['correctedQuery'] as String?,
      hasSpellCorrection: json['hasSpellCorrection'] as bool? ?? false,
      searchTerms: (json['searchTerms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SearchMetadataImplToJson(
  _$SearchMetadataImpl instance,
) => <String, dynamic>{
  'totalCount': instance.totalCount,
  'searchTime': instance.searchTime,
  'query': instance.query,
  'appliedFilters': instance.appliedFilters,
  'sortBy': instance.sortBy,
  'correctedQuery': instance.correctedQuery,
  'hasSpellCorrection': instance.hasSpellCorrection,
  'searchTerms': instance.searchTerms,
};

_$SearchSuggestionImpl _$$SearchSuggestionImplFromJson(
  Map<String, dynamic> json,
) => _$SearchSuggestionImpl(
  text: json['text'] as String,
  type: json['type'] as String,
  resultsCount: (json['resultsCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$SearchSuggestionImplToJson(
  _$SearchSuggestionImpl instance,
) => <String, dynamic>{
  'text': instance.text,
  'type': instance.type,
  'resultsCount': instance.resultsCount,
};

_$SearchFacetImpl _$$SearchFacetImplFromJson(Map<String, dynamic> json) =>
    _$SearchFacetImpl(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      values: (json['values'] as List<dynamic>)
          .map((e) => SearchFacetValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String? ?? 'single',
    );

Map<String, dynamic> _$$SearchFacetImplToJson(_$SearchFacetImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'values': instance.values,
      'type': instance.type,
    };

_$SearchFacetValueImpl _$$SearchFacetValueImplFromJson(
  Map<String, dynamic> json,
) => _$SearchFacetValueImpl(
  value: json['value'] as String,
  displayValue: json['displayValue'] as String,
  count: (json['count'] as num).toInt(),
  isSelected: json['isSelected'] as bool? ?? false,
);

Map<String, dynamic> _$$SearchFacetValueImplToJson(
  _$SearchFacetValueImpl instance,
) => <String, dynamic>{
  'value': instance.value,
  'displayValue': instance.displayValue,
  'count': instance.count,
  'isSelected': instance.isSelected,
};

_$SearchPaginationImpl _$$SearchPaginationImplFromJson(
  Map<String, dynamic> json,
) => _$SearchPaginationImpl(
  currentPage: (json['currentPage'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  hasNext: json['hasNext'] as bool,
  hasPrevious: json['hasPrevious'] as bool,
);

Map<String, dynamic> _$$SearchPaginationImplToJson(
  _$SearchPaginationImpl instance,
) => <String, dynamic>{
  'currentPage': instance.currentPage,
  'totalPages': instance.totalPages,
  'pageSize': instance.pageSize,
  'hasNext': instance.hasNext,
  'hasPrevious': instance.hasPrevious,
};

_$SearchAnalyticsImpl _$$SearchAnalyticsImplFromJson(
  Map<String, dynamic> json,
) => _$SearchAnalyticsImpl(
  sessionId: json['sessionId'] as String,
  query: json['query'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  resultsCount: (json['resultsCount'] as num?)?.toInt(),
  clickPosition: (json['clickPosition'] as num?)?.toInt(),
  clickedItemId: json['clickedItemId'] as String?,
  refinedQuery: json['refinedQuery'] as String?,
  filters: json['filters'] as Map<String, dynamic>?,
  searchDuration: (json['searchDuration'] as num?)?.toInt(),
  source: json['source'] as String?,
);

Map<String, dynamic> _$$SearchAnalyticsImplToJson(
  _$SearchAnalyticsImpl instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'query': instance.query,
  'timestamp': instance.timestamp.toIso8601String(),
  'resultsCount': instance.resultsCount,
  'clickPosition': instance.clickPosition,
  'clickedItemId': instance.clickedItemId,
  'refinedQuery': instance.refinedQuery,
  'filters': instance.filters,
  'searchDuration': instance.searchDuration,
  'source': instance.source,
};
