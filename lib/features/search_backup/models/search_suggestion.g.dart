// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchSuggestionImpl _$$SearchSuggestionImplFromJson(
  Map<String, dynamic> json,
) => _$SearchSuggestionImpl(
  text: json['text'] as String,
  type: $enumDecode(_$SearchSuggestionTypeEnumMap, json['type']),
  category: json['category'] as String?,
  imageUrl: json['imageUrl'] as String?,
  resultsCount: (json['resultsCount'] as num?)?.toInt() ?? 0,
  relevanceScore: (json['relevanceScore'] as num?)?.toDouble() ?? 0.0,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$SearchSuggestionImplToJson(
  _$SearchSuggestionImpl instance,
) => <String, dynamic>{
  'text': instance.text,
  'type': _$SearchSuggestionTypeEnumMap[instance.type]!,
  'category': instance.category,
  'imageUrl': instance.imageUrl,
  'resultsCount': instance.resultsCount,
  'relevanceScore': instance.relevanceScore,
  'metadata': instance.metadata,
};

const _$SearchSuggestionTypeEnumMap = {
  SearchSuggestionType.query: 'query',
  SearchSuggestionType.category: 'category',
  SearchSuggestionType.brand: 'brand',
  SearchSuggestionType.location: 'location',
  SearchSuggestionType.recent: 'recent',
  SearchSuggestionType.popular: 'popular',
  SearchSuggestionType.autocomplete: 'autocomplete',
};

_$SearchHistoryImpl _$$SearchHistoryImplFromJson(Map<String, dynamic> json) =>
    _$SearchHistoryImpl(
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      category: json['category'] as String?,
      location: json['location'] as String?,
      searchCount: (json['searchCount'] as num?)?.toInt() ?? 1,
      filters: json['filters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SearchHistoryImplToJson(_$SearchHistoryImpl instance) =>
    <String, dynamic>{
      'query': instance.query,
      'timestamp': instance.timestamp.toIso8601String(),
      'category': instance.category,
      'location': instance.location,
      'searchCount': instance.searchCount,
      'filters': instance.filters,
    };

_$PopularSearchImpl _$$PopularSearchImplFromJson(Map<String, dynamic> json) =>
    _$PopularSearchImpl(
      query: json['query'] as String,
      searchCount: (json['searchCount'] as num).toInt(),
      trendingScore: (json['trendingScore'] as num).toDouble(),
      category: json['category'] as String?,
      lastSearched: json['lastSearched'] == null
          ? null
          : DateTime.parse(json['lastSearched'] as String),
    );

Map<String, dynamic> _$$PopularSearchImplToJson(_$PopularSearchImpl instance) =>
    <String, dynamic>{
      'query': instance.query,
      'searchCount': instance.searchCount,
      'trendingScore': instance.trendingScore,
      'category': instance.category,
      'lastSearched': instance.lastSearched?.toIso8601String(),
    };
