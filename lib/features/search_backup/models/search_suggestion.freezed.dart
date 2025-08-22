// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SearchSuggestion _$SearchSuggestionFromJson(Map<String, dynamic> json) {
  return _SearchSuggestion.fromJson(json);
}

/// @nodoc
mixin _$SearchSuggestion {
  String get text => throw _privateConstructorUsedError;
  SearchSuggestionType get type => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int get resultsCount => throw _privateConstructorUsedError;
  double get relevanceScore => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this SearchSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchSuggestionCopyWith<SearchSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchSuggestionCopyWith<$Res> {
  factory $SearchSuggestionCopyWith(
    SearchSuggestion value,
    $Res Function(SearchSuggestion) then,
  ) = _$SearchSuggestionCopyWithImpl<$Res, SearchSuggestion>;
  @useResult
  $Res call({
    String text,
    SearchSuggestionType type,
    String? category,
    String? imageUrl,
    int resultsCount,
    double relevanceScore,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$SearchSuggestionCopyWithImpl<$Res, $Val extends SearchSuggestion>
    implements $SearchSuggestionCopyWith<$Res> {
  _$SearchSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? type = null,
    Object? category = freezed,
    Object? imageUrl = freezed,
    Object? resultsCount = null,
    Object? relevanceScore = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as SearchSuggestionType,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            resultsCount: null == resultsCount
                ? _value.resultsCount
                : resultsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            relevanceScore: null == relevanceScore
                ? _value.relevanceScore
                : relevanceScore // ignore: cast_nullable_to_non_nullable
                      as double,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchSuggestionImplCopyWith<$Res>
    implements $SearchSuggestionCopyWith<$Res> {
  factory _$$SearchSuggestionImplCopyWith(
    _$SearchSuggestionImpl value,
    $Res Function(_$SearchSuggestionImpl) then,
  ) = __$$SearchSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String text,
    SearchSuggestionType type,
    String? category,
    String? imageUrl,
    int resultsCount,
    double relevanceScore,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$SearchSuggestionImplCopyWithImpl<$Res>
    extends _$SearchSuggestionCopyWithImpl<$Res, _$SearchSuggestionImpl>
    implements _$$SearchSuggestionImplCopyWith<$Res> {
  __$$SearchSuggestionImplCopyWithImpl(
    _$SearchSuggestionImpl _value,
    $Res Function(_$SearchSuggestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? type = null,
    Object? category = freezed,
    Object? imageUrl = freezed,
    Object? resultsCount = null,
    Object? relevanceScore = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$SearchSuggestionImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as SearchSuggestionType,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        resultsCount: null == resultsCount
            ? _value.resultsCount
            : resultsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        relevanceScore: null == relevanceScore
            ? _value.relevanceScore
            : relevanceScore // ignore: cast_nullable_to_non_nullable
                  as double,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchSuggestionImpl implements _SearchSuggestion {
  const _$SearchSuggestionImpl({
    required this.text,
    required this.type,
    this.category,
    this.imageUrl,
    this.resultsCount = 0,
    this.relevanceScore = 0.0,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$SearchSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchSuggestionImplFromJson(json);

  @override
  final String text;
  @override
  final SearchSuggestionType type;
  @override
  final String? category;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final int resultsCount;
  @override
  @JsonKey()
  final double relevanceScore;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SearchSuggestion(text: $text, type: $type, category: $category, imageUrl: $imageUrl, resultsCount: $resultsCount, relevanceScore: $relevanceScore, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchSuggestionImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.resultsCount, resultsCount) ||
                other.resultsCount == resultsCount) &&
            (identical(other.relevanceScore, relevanceScore) ||
                other.relevanceScore == relevanceScore) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    text,
    type,
    category,
    imageUrl,
    resultsCount,
    relevanceScore,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of SearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchSuggestionImplCopyWith<_$SearchSuggestionImpl> get copyWith =>
      __$$SearchSuggestionImplCopyWithImpl<_$SearchSuggestionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchSuggestionImplToJson(this);
  }
}

abstract class _SearchSuggestion implements SearchSuggestion {
  const factory _SearchSuggestion({
    required final String text,
    required final SearchSuggestionType type,
    final String? category,
    final String? imageUrl,
    final int resultsCount,
    final double relevanceScore,
    final Map<String, dynamic>? metadata,
  }) = _$SearchSuggestionImpl;

  factory _SearchSuggestion.fromJson(Map<String, dynamic> json) =
      _$SearchSuggestionImpl.fromJson;

  @override
  String get text;
  @override
  SearchSuggestionType get type;
  @override
  String? get category;
  @override
  String? get imageUrl;
  @override
  int get resultsCount;
  @override
  double get relevanceScore;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of SearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchSuggestionImplCopyWith<_$SearchSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchHistory _$SearchHistoryFromJson(Map<String, dynamic> json) {
  return _SearchHistory.fromJson(json);
}

/// @nodoc
mixin _$SearchHistory {
  String get query => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  int get searchCount => throw _privateConstructorUsedError;
  Map<String, dynamic>? get filters => throw _privateConstructorUsedError;

  /// Serializes this SearchHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchHistoryCopyWith<SearchHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchHistoryCopyWith<$Res> {
  factory $SearchHistoryCopyWith(
    SearchHistory value,
    $Res Function(SearchHistory) then,
  ) = _$SearchHistoryCopyWithImpl<$Res, SearchHistory>;
  @useResult
  $Res call({
    String query,
    DateTime timestamp,
    String? category,
    String? location,
    int searchCount,
    Map<String, dynamic>? filters,
  });
}

/// @nodoc
class _$SearchHistoryCopyWithImpl<$Res, $Val extends SearchHistory>
    implements $SearchHistoryCopyWith<$Res> {
  _$SearchHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? timestamp = null,
    Object? category = freezed,
    Object? location = freezed,
    Object? searchCount = null,
    Object? filters = freezed,
  }) {
    return _then(
      _value.copyWith(
            query: null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            searchCount: null == searchCount
                ? _value.searchCount
                : searchCount // ignore: cast_nullable_to_non_nullable
                      as int,
            filters: freezed == filters
                ? _value.filters
                : filters // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchHistoryImplCopyWith<$Res>
    implements $SearchHistoryCopyWith<$Res> {
  factory _$$SearchHistoryImplCopyWith(
    _$SearchHistoryImpl value,
    $Res Function(_$SearchHistoryImpl) then,
  ) = __$$SearchHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String query,
    DateTime timestamp,
    String? category,
    String? location,
    int searchCount,
    Map<String, dynamic>? filters,
  });
}

/// @nodoc
class __$$SearchHistoryImplCopyWithImpl<$Res>
    extends _$SearchHistoryCopyWithImpl<$Res, _$SearchHistoryImpl>
    implements _$$SearchHistoryImplCopyWith<$Res> {
  __$$SearchHistoryImplCopyWithImpl(
    _$SearchHistoryImpl _value,
    $Res Function(_$SearchHistoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? timestamp = null,
    Object? category = freezed,
    Object? location = freezed,
    Object? searchCount = null,
    Object? filters = freezed,
  }) {
    return _then(
      _$SearchHistoryImpl(
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        searchCount: null == searchCount
            ? _value.searchCount
            : searchCount // ignore: cast_nullable_to_non_nullable
                  as int,
        filters: freezed == filters
            ? _value._filters
            : filters // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchHistoryImpl implements _SearchHistory {
  const _$SearchHistoryImpl({
    required this.query,
    required this.timestamp,
    this.category,
    this.location,
    this.searchCount = 1,
    final Map<String, dynamic>? filters,
  }) : _filters = filters;

  factory _$SearchHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchHistoryImplFromJson(json);

  @override
  final String query;
  @override
  final DateTime timestamp;
  @override
  final String? category;
  @override
  final String? location;
  @override
  @JsonKey()
  final int searchCount;
  final Map<String, dynamic>? _filters;
  @override
  Map<String, dynamic>? get filters {
    final value = _filters;
    if (value == null) return null;
    if (_filters is EqualUnmodifiableMapView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SearchHistory(query: $query, timestamp: $timestamp, category: $category, location: $location, searchCount: $searchCount, filters: $filters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchHistoryImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.searchCount, searchCount) ||
                other.searchCount == searchCount) &&
            const DeepCollectionEquality().equals(other._filters, _filters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    query,
    timestamp,
    category,
    location,
    searchCount,
    const DeepCollectionEquality().hash(_filters),
  );

  /// Create a copy of SearchHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchHistoryImplCopyWith<_$SearchHistoryImpl> get copyWith =>
      __$$SearchHistoryImplCopyWithImpl<_$SearchHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchHistoryImplToJson(this);
  }
}

abstract class _SearchHistory implements SearchHistory {
  const factory _SearchHistory({
    required final String query,
    required final DateTime timestamp,
    final String? category,
    final String? location,
    final int searchCount,
    final Map<String, dynamic>? filters,
  }) = _$SearchHistoryImpl;

  factory _SearchHistory.fromJson(Map<String, dynamic> json) =
      _$SearchHistoryImpl.fromJson;

  @override
  String get query;
  @override
  DateTime get timestamp;
  @override
  String? get category;
  @override
  String? get location;
  @override
  int get searchCount;
  @override
  Map<String, dynamic>? get filters;

  /// Create a copy of SearchHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchHistoryImplCopyWith<_$SearchHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PopularSearch _$PopularSearchFromJson(Map<String, dynamic> json) {
  return _PopularSearch.fromJson(json);
}

/// @nodoc
mixin _$PopularSearch {
  String get query => throw _privateConstructorUsedError;
  int get searchCount => throw _privateConstructorUsedError;
  double get trendingScore => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  DateTime? get lastSearched => throw _privateConstructorUsedError;

  /// Serializes this PopularSearch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PopularSearch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PopularSearchCopyWith<PopularSearch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PopularSearchCopyWith<$Res> {
  factory $PopularSearchCopyWith(
    PopularSearch value,
    $Res Function(PopularSearch) then,
  ) = _$PopularSearchCopyWithImpl<$Res, PopularSearch>;
  @useResult
  $Res call({
    String query,
    int searchCount,
    double trendingScore,
    String? category,
    DateTime? lastSearched,
  });
}

/// @nodoc
class _$PopularSearchCopyWithImpl<$Res, $Val extends PopularSearch>
    implements $PopularSearchCopyWith<$Res> {
  _$PopularSearchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PopularSearch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? searchCount = null,
    Object? trendingScore = null,
    Object? category = freezed,
    Object? lastSearched = freezed,
  }) {
    return _then(
      _value.copyWith(
            query: null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String,
            searchCount: null == searchCount
                ? _value.searchCount
                : searchCount // ignore: cast_nullable_to_non_nullable
                      as int,
            trendingScore: null == trendingScore
                ? _value.trendingScore
                : trendingScore // ignore: cast_nullable_to_non_nullable
                      as double,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastSearched: freezed == lastSearched
                ? _value.lastSearched
                : lastSearched // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PopularSearchImplCopyWith<$Res>
    implements $PopularSearchCopyWith<$Res> {
  factory _$$PopularSearchImplCopyWith(
    _$PopularSearchImpl value,
    $Res Function(_$PopularSearchImpl) then,
  ) = __$$PopularSearchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String query,
    int searchCount,
    double trendingScore,
    String? category,
    DateTime? lastSearched,
  });
}

/// @nodoc
class __$$PopularSearchImplCopyWithImpl<$Res>
    extends _$PopularSearchCopyWithImpl<$Res, _$PopularSearchImpl>
    implements _$$PopularSearchImplCopyWith<$Res> {
  __$$PopularSearchImplCopyWithImpl(
    _$PopularSearchImpl _value,
    $Res Function(_$PopularSearchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PopularSearch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? searchCount = null,
    Object? trendingScore = null,
    Object? category = freezed,
    Object? lastSearched = freezed,
  }) {
    return _then(
      _$PopularSearchImpl(
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
        searchCount: null == searchCount
            ? _value.searchCount
            : searchCount // ignore: cast_nullable_to_non_nullable
                  as int,
        trendingScore: null == trendingScore
            ? _value.trendingScore
            : trendingScore // ignore: cast_nullable_to_non_nullable
                  as double,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastSearched: freezed == lastSearched
            ? _value.lastSearched
            : lastSearched // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PopularSearchImpl implements _PopularSearch {
  const _$PopularSearchImpl({
    required this.query,
    required this.searchCount,
    required this.trendingScore,
    this.category,
    this.lastSearched,
  });

  factory _$PopularSearchImpl.fromJson(Map<String, dynamic> json) =>
      _$$PopularSearchImplFromJson(json);

  @override
  final String query;
  @override
  final int searchCount;
  @override
  final double trendingScore;
  @override
  final String? category;
  @override
  final DateTime? lastSearched;

  @override
  String toString() {
    return 'PopularSearch(query: $query, searchCount: $searchCount, trendingScore: $trendingScore, category: $category, lastSearched: $lastSearched)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PopularSearchImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.searchCount, searchCount) ||
                other.searchCount == searchCount) &&
            (identical(other.trendingScore, trendingScore) ||
                other.trendingScore == trendingScore) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.lastSearched, lastSearched) ||
                other.lastSearched == lastSearched));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    query,
    searchCount,
    trendingScore,
    category,
    lastSearched,
  );

  /// Create a copy of PopularSearch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PopularSearchImplCopyWith<_$PopularSearchImpl> get copyWith =>
      __$$PopularSearchImplCopyWithImpl<_$PopularSearchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PopularSearchImplToJson(this);
  }
}

abstract class _PopularSearch implements PopularSearch {
  const factory _PopularSearch({
    required final String query,
    required final int searchCount,
    required final double trendingScore,
    final String? category,
    final DateTime? lastSearched,
  }) = _$PopularSearchImpl;

  factory _PopularSearch.fromJson(Map<String, dynamic> json) =
      _$PopularSearchImpl.fromJson;

  @override
  String get query;
  @override
  int get searchCount;
  @override
  double get trendingScore;
  @override
  String? get category;
  @override
  DateTime? get lastSearched;

  /// Create a copy of PopularSearch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PopularSearchImplCopyWith<_$PopularSearchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
