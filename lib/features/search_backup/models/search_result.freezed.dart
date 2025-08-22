// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) {
  return _SearchResult.fromJson(json);
}

/// @nodoc
mixin _$SearchResult {
  List<ItemModel> get items => throw _privateConstructorUsedError;
  SearchMetadata get metadata => throw _privateConstructorUsedError;
  List<SearchSuggestion>? get suggestions => throw _privateConstructorUsedError;
  List<SearchFacet>? get facets => throw _privateConstructorUsedError;
  SearchPagination? get pagination => throw _privateConstructorUsedError;

  /// Serializes this SearchResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResultCopyWith<SearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultCopyWith<$Res> {
  factory $SearchResultCopyWith(
    SearchResult value,
    $Res Function(SearchResult) then,
  ) = _$SearchResultCopyWithImpl<$Res, SearchResult>;
  @useResult
  $Res call({
    List<ItemModel> items,
    SearchMetadata metadata,
    List<SearchSuggestion>? suggestions,
    List<SearchFacet>? facets,
    SearchPagination? pagination,
  });

  $SearchMetadataCopyWith<$Res> get metadata;
  $SearchPaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class _$SearchResultCopyWithImpl<$Res, $Val extends SearchResult>
    implements $SearchResultCopyWith<$Res> {
  _$SearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? metadata = null,
    Object? suggestions = freezed,
    Object? facets = freezed,
    Object? pagination = freezed,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ItemModel>,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as SearchMetadata,
            suggestions: freezed == suggestions
                ? _value.suggestions
                : suggestions // ignore: cast_nullable_to_non_nullable
                      as List<SearchSuggestion>?,
            facets: freezed == facets
                ? _value.facets
                : facets // ignore: cast_nullable_to_non_nullable
                      as List<SearchFacet>?,
            pagination: freezed == pagination
                ? _value.pagination
                : pagination // ignore: cast_nullable_to_non_nullable
                      as SearchPagination?,
          )
          as $Val,
    );
  }

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchMetadataCopyWith<$Res> get metadata {
    return $SearchMetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchPaginationCopyWith<$Res>? get pagination {
    if (_value.pagination == null) {
      return null;
    }

    return $SearchPaginationCopyWith<$Res>(_value.pagination!, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SearchResultImplCopyWith<$Res>
    implements $SearchResultCopyWith<$Res> {
  factory _$$SearchResultImplCopyWith(
    _$SearchResultImpl value,
    $Res Function(_$SearchResultImpl) then,
  ) = __$$SearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ItemModel> items,
    SearchMetadata metadata,
    List<SearchSuggestion>? suggestions,
    List<SearchFacet>? facets,
    SearchPagination? pagination,
  });

  @override
  $SearchMetadataCopyWith<$Res> get metadata;
  @override
  $SearchPaginationCopyWith<$Res>? get pagination;
}

/// @nodoc
class __$$SearchResultImplCopyWithImpl<$Res>
    extends _$SearchResultCopyWithImpl<$Res, _$SearchResultImpl>
    implements _$$SearchResultImplCopyWith<$Res> {
  __$$SearchResultImplCopyWithImpl(
    _$SearchResultImpl _value,
    $Res Function(_$SearchResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? metadata = null,
    Object? suggestions = freezed,
    Object? facets = freezed,
    Object? pagination = freezed,
  }) {
    return _then(
      _$SearchResultImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ItemModel>,
        metadata: null == metadata
            ? _value.metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as SearchMetadata,
        suggestions: freezed == suggestions
            ? _value._suggestions
            : suggestions // ignore: cast_nullable_to_non_nullable
                  as List<SearchSuggestion>?,
        facets: freezed == facets
            ? _value._facets
            : facets // ignore: cast_nullable_to_non_nullable
                  as List<SearchFacet>?,
        pagination: freezed == pagination
            ? _value.pagination
            : pagination // ignore: cast_nullable_to_non_nullable
                  as SearchPagination?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResultImpl implements _SearchResult {
  const _$SearchResultImpl({
    required final List<ItemModel> items,
    required this.metadata,
    final List<SearchSuggestion>? suggestions,
    final List<SearchFacet>? facets,
    this.pagination,
  }) : _items = items,
       _suggestions = suggestions,
       _facets = facets;

  factory _$SearchResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResultImplFromJson(json);

  final List<ItemModel> _items;
  @override
  List<ItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final SearchMetadata metadata;
  final List<SearchSuggestion>? _suggestions;
  @override
  List<SearchSuggestion>? get suggestions {
    final value = _suggestions;
    if (value == null) return null;
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SearchFacet>? _facets;
  @override
  List<SearchFacet>? get facets {
    final value = _facets;
    if (value == null) return null;
    if (_facets is EqualUnmodifiableListView) return _facets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final SearchPagination? pagination;

  @override
  String toString() {
    return 'SearchResult(items: $items, metadata: $metadata, suggestions: $suggestions, facets: $facets, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            const DeepCollectionEquality().equals(
              other._suggestions,
              _suggestions,
            ) &&
            const DeepCollectionEquality().equals(other._facets, _facets) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    metadata,
    const DeepCollectionEquality().hash(_suggestions),
    const DeepCollectionEquality().hash(_facets),
    pagination,
  );

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      __$$SearchResultImplCopyWithImpl<_$SearchResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResultImplToJson(this);
  }
}

abstract class _SearchResult implements SearchResult {
  const factory _SearchResult({
    required final List<ItemModel> items,
    required final SearchMetadata metadata,
    final List<SearchSuggestion>? suggestions,
    final List<SearchFacet>? facets,
    final SearchPagination? pagination,
  }) = _$SearchResultImpl;

  factory _SearchResult.fromJson(Map<String, dynamic> json) =
      _$SearchResultImpl.fromJson;

  @override
  List<ItemModel> get items;
  @override
  SearchMetadata get metadata;
  @override
  List<SearchSuggestion>? get suggestions;
  @override
  List<SearchFacet>? get facets;
  @override
  SearchPagination? get pagination;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultImplCopyWith<_$SearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchMetadata _$SearchMetadataFromJson(Map<String, dynamic> json) {
  return _SearchMetadata.fromJson(json);
}

/// @nodoc
mixin _$SearchMetadata {
  int get totalCount => throw _privateConstructorUsedError;
  int get searchTime => throw _privateConstructorUsedError; // milliseconds
  String get query => throw _privateConstructorUsedError;
  Map<String, dynamic>? get appliedFilters =>
      throw _privateConstructorUsedError;
  String? get sortBy => throw _privateConstructorUsedError;
  String? get correctedQuery => throw _privateConstructorUsedError;
  bool get hasSpellCorrection => throw _privateConstructorUsedError;
  List<String>? get searchTerms => throw _privateConstructorUsedError;

  /// Serializes this SearchMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchMetadataCopyWith<SearchMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchMetadataCopyWith<$Res> {
  factory $SearchMetadataCopyWith(
    SearchMetadata value,
    $Res Function(SearchMetadata) then,
  ) = _$SearchMetadataCopyWithImpl<$Res, SearchMetadata>;
  @useResult
  $Res call({
    int totalCount,
    int searchTime,
    String query,
    Map<String, dynamic>? appliedFilters,
    String? sortBy,
    String? correctedQuery,
    bool hasSpellCorrection,
    List<String>? searchTerms,
  });
}

/// @nodoc
class _$SearchMetadataCopyWithImpl<$Res, $Val extends SearchMetadata>
    implements $SearchMetadataCopyWith<$Res> {
  _$SearchMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? searchTime = null,
    Object? query = null,
    Object? appliedFilters = freezed,
    Object? sortBy = freezed,
    Object? correctedQuery = freezed,
    Object? hasSpellCorrection = null,
    Object? searchTerms = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            searchTime: null == searchTime
                ? _value.searchTime
                : searchTime // ignore: cast_nullable_to_non_nullable
                      as int,
            query: null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String,
            appliedFilters: freezed == appliedFilters
                ? _value.appliedFilters
                : appliedFilters // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            sortBy: freezed == sortBy
                ? _value.sortBy
                : sortBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            correctedQuery: freezed == correctedQuery
                ? _value.correctedQuery
                : correctedQuery // ignore: cast_nullable_to_non_nullable
                      as String?,
            hasSpellCorrection: null == hasSpellCorrection
                ? _value.hasSpellCorrection
                : hasSpellCorrection // ignore: cast_nullable_to_non_nullable
                      as bool,
            searchTerms: freezed == searchTerms
                ? _value.searchTerms
                : searchTerms // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchMetadataImplCopyWith<$Res>
    implements $SearchMetadataCopyWith<$Res> {
  factory _$$SearchMetadataImplCopyWith(
    _$SearchMetadataImpl value,
    $Res Function(_$SearchMetadataImpl) then,
  ) = __$$SearchMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalCount,
    int searchTime,
    String query,
    Map<String, dynamic>? appliedFilters,
    String? sortBy,
    String? correctedQuery,
    bool hasSpellCorrection,
    List<String>? searchTerms,
  });
}

/// @nodoc
class __$$SearchMetadataImplCopyWithImpl<$Res>
    extends _$SearchMetadataCopyWithImpl<$Res, _$SearchMetadataImpl>
    implements _$$SearchMetadataImplCopyWith<$Res> {
  __$$SearchMetadataImplCopyWithImpl(
    _$SearchMetadataImpl _value,
    $Res Function(_$SearchMetadataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? searchTime = null,
    Object? query = null,
    Object? appliedFilters = freezed,
    Object? sortBy = freezed,
    Object? correctedQuery = freezed,
    Object? hasSpellCorrection = null,
    Object? searchTerms = freezed,
  }) {
    return _then(
      _$SearchMetadataImpl(
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        searchTime: null == searchTime
            ? _value.searchTime
            : searchTime // ignore: cast_nullable_to_non_nullable
                  as int,
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
        appliedFilters: freezed == appliedFilters
            ? _value._appliedFilters
            : appliedFilters // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        sortBy: freezed == sortBy
            ? _value.sortBy
            : sortBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        correctedQuery: freezed == correctedQuery
            ? _value.correctedQuery
            : correctedQuery // ignore: cast_nullable_to_non_nullable
                  as String?,
        hasSpellCorrection: null == hasSpellCorrection
            ? _value.hasSpellCorrection
            : hasSpellCorrection // ignore: cast_nullable_to_non_nullable
                  as bool,
        searchTerms: freezed == searchTerms
            ? _value._searchTerms
            : searchTerms // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchMetadataImpl implements _SearchMetadata {
  const _$SearchMetadataImpl({
    required this.totalCount,
    required this.searchTime,
    required this.query,
    final Map<String, dynamic>? appliedFilters,
    this.sortBy,
    this.correctedQuery,
    this.hasSpellCorrection = false,
    final List<String>? searchTerms,
  }) : _appliedFilters = appliedFilters,
       _searchTerms = searchTerms;

  factory _$SearchMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchMetadataImplFromJson(json);

  @override
  final int totalCount;
  @override
  final int searchTime;
  // milliseconds
  @override
  final String query;
  final Map<String, dynamic>? _appliedFilters;
  @override
  Map<String, dynamic>? get appliedFilters {
    final value = _appliedFilters;
    if (value == null) return null;
    if (_appliedFilters is EqualUnmodifiableMapView) return _appliedFilters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? sortBy;
  @override
  final String? correctedQuery;
  @override
  @JsonKey()
  final bool hasSpellCorrection;
  final List<String>? _searchTerms;
  @override
  List<String>? get searchTerms {
    final value = _searchTerms;
    if (value == null) return null;
    if (_searchTerms is EqualUnmodifiableListView) return _searchTerms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SearchMetadata(totalCount: $totalCount, searchTime: $searchTime, query: $query, appliedFilters: $appliedFilters, sortBy: $sortBy, correctedQuery: $correctedQuery, hasSpellCorrection: $hasSpellCorrection, searchTerms: $searchTerms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchMetadataImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.searchTime, searchTime) ||
                other.searchTime == searchTime) &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality().equals(
              other._appliedFilters,
              _appliedFilters,
            ) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.correctedQuery, correctedQuery) ||
                other.correctedQuery == correctedQuery) &&
            (identical(other.hasSpellCorrection, hasSpellCorrection) ||
                other.hasSpellCorrection == hasSpellCorrection) &&
            const DeepCollectionEquality().equals(
              other._searchTerms,
              _searchTerms,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalCount,
    searchTime,
    query,
    const DeepCollectionEquality().hash(_appliedFilters),
    sortBy,
    correctedQuery,
    hasSpellCorrection,
    const DeepCollectionEquality().hash(_searchTerms),
  );

  /// Create a copy of SearchMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchMetadataImplCopyWith<_$SearchMetadataImpl> get copyWith =>
      __$$SearchMetadataImplCopyWithImpl<_$SearchMetadataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchMetadataImplToJson(this);
  }
}

abstract class _SearchMetadata implements SearchMetadata {
  const factory _SearchMetadata({
    required final int totalCount,
    required final int searchTime,
    required final String query,
    final Map<String, dynamic>? appliedFilters,
    final String? sortBy,
    final String? correctedQuery,
    final bool hasSpellCorrection,
    final List<String>? searchTerms,
  }) = _$SearchMetadataImpl;

  factory _SearchMetadata.fromJson(Map<String, dynamic> json) =
      _$SearchMetadataImpl.fromJson;

  @override
  int get totalCount;
  @override
  int get searchTime; // milliseconds
  @override
  String get query;
  @override
  Map<String, dynamic>? get appliedFilters;
  @override
  String? get sortBy;
  @override
  String? get correctedQuery;
  @override
  bool get hasSpellCorrection;
  @override
  List<String>? get searchTerms;

  /// Create a copy of SearchMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchMetadataImplCopyWith<_$SearchMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchSuggestion _$SearchSuggestionFromJson(Map<String, dynamic> json) {
  return _SearchSuggestion.fromJson(json);
}

/// @nodoc
mixin _$SearchSuggestion {
  String get text => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get resultsCount => throw _privateConstructorUsedError;

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
  $Res call({String text, String type, int resultsCount});
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
    Object? resultsCount = null,
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
                      as String,
            resultsCount: null == resultsCount
                ? _value.resultsCount
                : resultsCount // ignore: cast_nullable_to_non_nullable
                      as int,
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
  $Res call({String text, String type, int resultsCount});
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
    Object? resultsCount = null,
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
                  as String,
        resultsCount: null == resultsCount
            ? _value.resultsCount
            : resultsCount // ignore: cast_nullable_to_non_nullable
                  as int,
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
    this.resultsCount = 0,
  });

  factory _$SearchSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchSuggestionImplFromJson(json);

  @override
  final String text;
  @override
  final String type;
  @override
  @JsonKey()
  final int resultsCount;

  @override
  String toString() {
    return 'SearchSuggestion(text: $text, type: $type, resultsCount: $resultsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchSuggestionImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.resultsCount, resultsCount) ||
                other.resultsCount == resultsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, type, resultsCount);

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
    required final String type,
    final int resultsCount,
  }) = _$SearchSuggestionImpl;

  factory _SearchSuggestion.fromJson(Map<String, dynamic> json) =
      _$SearchSuggestionImpl.fromJson;

  @override
  String get text;
  @override
  String get type;
  @override
  int get resultsCount;

  /// Create a copy of SearchSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchSuggestionImplCopyWith<_$SearchSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchFacet _$SearchFacetFromJson(Map<String, dynamic> json) {
  return _SearchFacet.fromJson(json);
}

/// @nodoc
mixin _$SearchFacet {
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  List<SearchFacetValue> get values => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this SearchFacet to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchFacet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchFacetCopyWith<SearchFacet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchFacetCopyWith<$Res> {
  factory $SearchFacetCopyWith(
    SearchFacet value,
    $Res Function(SearchFacet) then,
  ) = _$SearchFacetCopyWithImpl<$Res, SearchFacet>;
  @useResult
  $Res call({
    String name,
    String displayName,
    List<SearchFacetValue> values,
    String type,
  });
}

/// @nodoc
class _$SearchFacetCopyWithImpl<$Res, $Val extends SearchFacet>
    implements $SearchFacetCopyWith<$Res> {
  _$SearchFacetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchFacet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? displayName = null,
    Object? values = null,
    Object? type = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            values: null == values
                ? _value.values
                : values // ignore: cast_nullable_to_non_nullable
                      as List<SearchFacetValue>,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchFacetImplCopyWith<$Res>
    implements $SearchFacetCopyWith<$Res> {
  factory _$$SearchFacetImplCopyWith(
    _$SearchFacetImpl value,
    $Res Function(_$SearchFacetImpl) then,
  ) = __$$SearchFacetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String displayName,
    List<SearchFacetValue> values,
    String type,
  });
}

/// @nodoc
class __$$SearchFacetImplCopyWithImpl<$Res>
    extends _$SearchFacetCopyWithImpl<$Res, _$SearchFacetImpl>
    implements _$$SearchFacetImplCopyWith<$Res> {
  __$$SearchFacetImplCopyWithImpl(
    _$SearchFacetImpl _value,
    $Res Function(_$SearchFacetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchFacet
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? displayName = null,
    Object? values = null,
    Object? type = null,
  }) {
    return _then(
      _$SearchFacetImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        values: null == values
            ? _value._values
            : values // ignore: cast_nullable_to_non_nullable
                  as List<SearchFacetValue>,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchFacetImpl implements _SearchFacet {
  const _$SearchFacetImpl({
    required this.name,
    required this.displayName,
    required final List<SearchFacetValue> values,
    this.type = 'single',
  }) : _values = values;

  factory _$SearchFacetImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchFacetImplFromJson(json);

  @override
  final String name;
  @override
  final String displayName;
  final List<SearchFacetValue> _values;
  @override
  List<SearchFacetValue> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @override
  @JsonKey()
  final String type;

  @override
  String toString() {
    return 'SearchFacet(name: $name, displayName: $displayName, values: $values, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFacetImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    displayName,
    const DeepCollectionEquality().hash(_values),
    type,
  );

  /// Create a copy of SearchFacet
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFacetImplCopyWith<_$SearchFacetImpl> get copyWith =>
      __$$SearchFacetImplCopyWithImpl<_$SearchFacetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchFacetImplToJson(this);
  }
}

abstract class _SearchFacet implements SearchFacet {
  const factory _SearchFacet({
    required final String name,
    required final String displayName,
    required final List<SearchFacetValue> values,
    final String type,
  }) = _$SearchFacetImpl;

  factory _SearchFacet.fromJson(Map<String, dynamic> json) =
      _$SearchFacetImpl.fromJson;

  @override
  String get name;
  @override
  String get displayName;
  @override
  List<SearchFacetValue> get values;
  @override
  String get type;

  /// Create a copy of SearchFacet
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFacetImplCopyWith<_$SearchFacetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchFacetValue _$SearchFacetValueFromJson(Map<String, dynamic> json) {
  return _SearchFacetValue.fromJson(json);
}

/// @nodoc
mixin _$SearchFacetValue {
  String get value => throw _privateConstructorUsedError;
  String get displayValue => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

  /// Serializes this SearchFacetValue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchFacetValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchFacetValueCopyWith<SearchFacetValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchFacetValueCopyWith<$Res> {
  factory $SearchFacetValueCopyWith(
    SearchFacetValue value,
    $Res Function(SearchFacetValue) then,
  ) = _$SearchFacetValueCopyWithImpl<$Res, SearchFacetValue>;
  @useResult
  $Res call({String value, String displayValue, int count, bool isSelected});
}

/// @nodoc
class _$SearchFacetValueCopyWithImpl<$Res, $Val extends SearchFacetValue>
    implements $SearchFacetValueCopyWith<$Res> {
  _$SearchFacetValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchFacetValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? displayValue = null,
    Object? count = null,
    Object? isSelected = null,
  }) {
    return _then(
      _value.copyWith(
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
            displayValue: null == displayValue
                ? _value.displayValue
                : displayValue // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            isSelected: null == isSelected
                ? _value.isSelected
                : isSelected // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchFacetValueImplCopyWith<$Res>
    implements $SearchFacetValueCopyWith<$Res> {
  factory _$$SearchFacetValueImplCopyWith(
    _$SearchFacetValueImpl value,
    $Res Function(_$SearchFacetValueImpl) then,
  ) = __$$SearchFacetValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value, String displayValue, int count, bool isSelected});
}

/// @nodoc
class __$$SearchFacetValueImplCopyWithImpl<$Res>
    extends _$SearchFacetValueCopyWithImpl<$Res, _$SearchFacetValueImpl>
    implements _$$SearchFacetValueImplCopyWith<$Res> {
  __$$SearchFacetValueImplCopyWithImpl(
    _$SearchFacetValueImpl _value,
    $Res Function(_$SearchFacetValueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchFacetValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? displayValue = null,
    Object? count = null,
    Object? isSelected = null,
  }) {
    return _then(
      _$SearchFacetValueImpl(
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        displayValue: null == displayValue
            ? _value.displayValue
            : displayValue // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        isSelected: null == isSelected
            ? _value.isSelected
            : isSelected // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchFacetValueImpl implements _SearchFacetValue {
  const _$SearchFacetValueImpl({
    required this.value,
    required this.displayValue,
    required this.count,
    this.isSelected = false,
  });

  factory _$SearchFacetValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchFacetValueImplFromJson(json);

  @override
  final String value;
  @override
  final String displayValue;
  @override
  final int count;
  @override
  @JsonKey()
  final bool isSelected;

  @override
  String toString() {
    return 'SearchFacetValue(value: $value, displayValue: $displayValue, count: $count, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFacetValueImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.displayValue, displayValue) ||
                other.displayValue == displayValue) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, value, displayValue, count, isSelected);

  /// Create a copy of SearchFacetValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFacetValueImplCopyWith<_$SearchFacetValueImpl> get copyWith =>
      __$$SearchFacetValueImplCopyWithImpl<_$SearchFacetValueImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchFacetValueImplToJson(this);
  }
}

abstract class _SearchFacetValue implements SearchFacetValue {
  const factory _SearchFacetValue({
    required final String value,
    required final String displayValue,
    required final int count,
    final bool isSelected,
  }) = _$SearchFacetValueImpl;

  factory _SearchFacetValue.fromJson(Map<String, dynamic> json) =
      _$SearchFacetValueImpl.fromJson;

  @override
  String get value;
  @override
  String get displayValue;
  @override
  int get count;
  @override
  bool get isSelected;

  /// Create a copy of SearchFacetValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFacetValueImplCopyWith<_$SearchFacetValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchPagination _$SearchPaginationFromJson(Map<String, dynamic> json) {
  return _SearchPagination.fromJson(json);
}

/// @nodoc
mixin _$SearchPagination {
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  bool get hasNext => throw _privateConstructorUsedError;
  bool get hasPrevious => throw _privateConstructorUsedError;

  /// Serializes this SearchPagination to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchPagination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchPaginationCopyWith<SearchPagination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchPaginationCopyWith<$Res> {
  factory $SearchPaginationCopyWith(
    SearchPagination value,
    $Res Function(SearchPagination) then,
  ) = _$SearchPaginationCopyWithImpl<$Res, SearchPagination>;
  @useResult
  $Res call({
    int currentPage,
    int totalPages,
    int pageSize,
    bool hasNext,
    bool hasPrevious,
  });
}

/// @nodoc
class _$SearchPaginationCopyWithImpl<$Res, $Val extends SearchPagination>
    implements $SearchPaginationCopyWith<$Res> {
  _$SearchPaginationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchPagination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? totalPages = null,
    Object? pageSize = null,
    Object? hasNext = null,
    Object? hasPrevious = null,
  }) {
    return _then(
      _value.copyWith(
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            pageSize: null == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                      as int,
            hasNext: null == hasNext
                ? _value.hasNext
                : hasNext // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasPrevious: null == hasPrevious
                ? _value.hasPrevious
                : hasPrevious // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchPaginationImplCopyWith<$Res>
    implements $SearchPaginationCopyWith<$Res> {
  factory _$$SearchPaginationImplCopyWith(
    _$SearchPaginationImpl value,
    $Res Function(_$SearchPaginationImpl) then,
  ) = __$$SearchPaginationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentPage,
    int totalPages,
    int pageSize,
    bool hasNext,
    bool hasPrevious,
  });
}

/// @nodoc
class __$$SearchPaginationImplCopyWithImpl<$Res>
    extends _$SearchPaginationCopyWithImpl<$Res, _$SearchPaginationImpl>
    implements _$$SearchPaginationImplCopyWith<$Res> {
  __$$SearchPaginationImplCopyWithImpl(
    _$SearchPaginationImpl _value,
    $Res Function(_$SearchPaginationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchPagination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? totalPages = null,
    Object? pageSize = null,
    Object? hasNext = null,
    Object? hasPrevious = null,
  }) {
    return _then(
      _$SearchPaginationImpl(
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        pageSize: null == pageSize
            ? _value.pageSize
            : pageSize // ignore: cast_nullable_to_non_nullable
                  as int,
        hasNext: null == hasNext
            ? _value.hasNext
            : hasNext // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasPrevious: null == hasPrevious
            ? _value.hasPrevious
            : hasPrevious // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchPaginationImpl implements _SearchPagination {
  const _$SearchPaginationImpl({
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory _$SearchPaginationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchPaginationImplFromJson(json);

  @override
  final int currentPage;
  @override
  final int totalPages;
  @override
  final int pageSize;
  @override
  final bool hasNext;
  @override
  final bool hasPrevious;

  @override
  String toString() {
    return 'SearchPagination(currentPage: $currentPage, totalPages: $totalPages, pageSize: $pageSize, hasNext: $hasNext, hasPrevious: $hasPrevious)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchPaginationImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.hasPrevious, hasPrevious) ||
                other.hasPrevious == hasPrevious));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentPage,
    totalPages,
    pageSize,
    hasNext,
    hasPrevious,
  );

  /// Create a copy of SearchPagination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchPaginationImplCopyWith<_$SearchPaginationImpl> get copyWith =>
      __$$SearchPaginationImplCopyWithImpl<_$SearchPaginationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchPaginationImplToJson(this);
  }
}

abstract class _SearchPagination implements SearchPagination {
  const factory _SearchPagination({
    required final int currentPage,
    required final int totalPages,
    required final int pageSize,
    required final bool hasNext,
    required final bool hasPrevious,
  }) = _$SearchPaginationImpl;

  factory _SearchPagination.fromJson(Map<String, dynamic> json) =
      _$SearchPaginationImpl.fromJson;

  @override
  int get currentPage;
  @override
  int get totalPages;
  @override
  int get pageSize;
  @override
  bool get hasNext;
  @override
  bool get hasPrevious;

  /// Create a copy of SearchPagination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchPaginationImplCopyWith<_$SearchPaginationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SearchAnalytics _$SearchAnalyticsFromJson(Map<String, dynamic> json) {
  return _SearchAnalytics.fromJson(json);
}

/// @nodoc
mixin _$SearchAnalytics {
  String get sessionId => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  int? get resultsCount => throw _privateConstructorUsedError;
  int? get clickPosition => throw _privateConstructorUsedError;
  String? get clickedItemId => throw _privateConstructorUsedError;
  String? get refinedQuery => throw _privateConstructorUsedError;
  Map<String, dynamic>? get filters => throw _privateConstructorUsedError;
  int? get searchDuration => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;

  /// Serializes this SearchAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchAnalyticsCopyWith<SearchAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchAnalyticsCopyWith<$Res> {
  factory $SearchAnalyticsCopyWith(
    SearchAnalytics value,
    $Res Function(SearchAnalytics) then,
  ) = _$SearchAnalyticsCopyWithImpl<$Res, SearchAnalytics>;
  @useResult
  $Res call({
    String sessionId,
    String query,
    DateTime timestamp,
    int? resultsCount,
    int? clickPosition,
    String? clickedItemId,
    String? refinedQuery,
    Map<String, dynamic>? filters,
    int? searchDuration,
    String? source,
  });
}

/// @nodoc
class _$SearchAnalyticsCopyWithImpl<$Res, $Val extends SearchAnalytics>
    implements $SearchAnalyticsCopyWith<$Res> {
  _$SearchAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? query = null,
    Object? timestamp = null,
    Object? resultsCount = freezed,
    Object? clickPosition = freezed,
    Object? clickedItemId = freezed,
    Object? refinedQuery = freezed,
    Object? filters = freezed,
    Object? searchDuration = freezed,
    Object? source = freezed,
  }) {
    return _then(
      _value.copyWith(
            sessionId: null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            query: null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            resultsCount: freezed == resultsCount
                ? _value.resultsCount
                : resultsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            clickPosition: freezed == clickPosition
                ? _value.clickPosition
                : clickPosition // ignore: cast_nullable_to_non_nullable
                      as int?,
            clickedItemId: freezed == clickedItemId
                ? _value.clickedItemId
                : clickedItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            refinedQuery: freezed == refinedQuery
                ? _value.refinedQuery
                : refinedQuery // ignore: cast_nullable_to_non_nullable
                      as String?,
            filters: freezed == filters
                ? _value.filters
                : filters // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            searchDuration: freezed == searchDuration
                ? _value.searchDuration
                : searchDuration // ignore: cast_nullable_to_non_nullable
                      as int?,
            source: freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchAnalyticsImplCopyWith<$Res>
    implements $SearchAnalyticsCopyWith<$Res> {
  factory _$$SearchAnalyticsImplCopyWith(
    _$SearchAnalyticsImpl value,
    $Res Function(_$SearchAnalyticsImpl) then,
  ) = __$$SearchAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sessionId,
    String query,
    DateTime timestamp,
    int? resultsCount,
    int? clickPosition,
    String? clickedItemId,
    String? refinedQuery,
    Map<String, dynamic>? filters,
    int? searchDuration,
    String? source,
  });
}

/// @nodoc
class __$$SearchAnalyticsImplCopyWithImpl<$Res>
    extends _$SearchAnalyticsCopyWithImpl<$Res, _$SearchAnalyticsImpl>
    implements _$$SearchAnalyticsImplCopyWith<$Res> {
  __$$SearchAnalyticsImplCopyWithImpl(
    _$SearchAnalyticsImpl _value,
    $Res Function(_$SearchAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? query = null,
    Object? timestamp = null,
    Object? resultsCount = freezed,
    Object? clickPosition = freezed,
    Object? clickedItemId = freezed,
    Object? refinedQuery = freezed,
    Object? filters = freezed,
    Object? searchDuration = freezed,
    Object? source = freezed,
  }) {
    return _then(
      _$SearchAnalyticsImpl(
        sessionId: null == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        resultsCount: freezed == resultsCount
            ? _value.resultsCount
            : resultsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        clickPosition: freezed == clickPosition
            ? _value.clickPosition
            : clickPosition // ignore: cast_nullable_to_non_nullable
                  as int?,
        clickedItemId: freezed == clickedItemId
            ? _value.clickedItemId
            : clickedItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        refinedQuery: freezed == refinedQuery
            ? _value.refinedQuery
            : refinedQuery // ignore: cast_nullable_to_non_nullable
                  as String?,
        filters: freezed == filters
            ? _value._filters
            : filters // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        searchDuration: freezed == searchDuration
            ? _value.searchDuration
            : searchDuration // ignore: cast_nullable_to_non_nullable
                  as int?,
        source: freezed == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchAnalyticsImpl implements _SearchAnalytics {
  const _$SearchAnalyticsImpl({
    required this.sessionId,
    required this.query,
    required this.timestamp,
    this.resultsCount,
    this.clickPosition,
    this.clickedItemId,
    this.refinedQuery,
    final Map<String, dynamic>? filters,
    this.searchDuration,
    this.source,
  }) : _filters = filters;

  factory _$SearchAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchAnalyticsImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String query;
  @override
  final DateTime timestamp;
  @override
  final int? resultsCount;
  @override
  final int? clickPosition;
  @override
  final String? clickedItemId;
  @override
  final String? refinedQuery;
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
  final int? searchDuration;
  @override
  final String? source;

  @override
  String toString() {
    return 'SearchAnalytics(sessionId: $sessionId, query: $query, timestamp: $timestamp, resultsCount: $resultsCount, clickPosition: $clickPosition, clickedItemId: $clickedItemId, refinedQuery: $refinedQuery, filters: $filters, searchDuration: $searchDuration, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchAnalyticsImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.resultsCount, resultsCount) ||
                other.resultsCount == resultsCount) &&
            (identical(other.clickPosition, clickPosition) ||
                other.clickPosition == clickPosition) &&
            (identical(other.clickedItemId, clickedItemId) ||
                other.clickedItemId == clickedItemId) &&
            (identical(other.refinedQuery, refinedQuery) ||
                other.refinedQuery == refinedQuery) &&
            const DeepCollectionEquality().equals(other._filters, _filters) &&
            (identical(other.searchDuration, searchDuration) ||
                other.searchDuration == searchDuration) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sessionId,
    query,
    timestamp,
    resultsCount,
    clickPosition,
    clickedItemId,
    refinedQuery,
    const DeepCollectionEquality().hash(_filters),
    searchDuration,
    source,
  );

  /// Create a copy of SearchAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchAnalyticsImplCopyWith<_$SearchAnalyticsImpl> get copyWith =>
      __$$SearchAnalyticsImplCopyWithImpl<_$SearchAnalyticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchAnalyticsImplToJson(this);
  }
}

abstract class _SearchAnalytics implements SearchAnalytics {
  const factory _SearchAnalytics({
    required final String sessionId,
    required final String query,
    required final DateTime timestamp,
    final int? resultsCount,
    final int? clickPosition,
    final String? clickedItemId,
    final String? refinedQuery,
    final Map<String, dynamic>? filters,
    final int? searchDuration,
    final String? source,
  }) = _$SearchAnalyticsImpl;

  factory _SearchAnalytics.fromJson(Map<String, dynamic> json) =
      _$SearchAnalyticsImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get query;
  @override
  DateTime get timestamp;
  @override
  int? get resultsCount;
  @override
  int? get clickPosition;
  @override
  String? get clickedItemId;
  @override
  String? get refinedQuery;
  @override
  Map<String, dynamic>? get filters;
  @override
  int? get searchDuration;
  @override
  String? get source;

  /// Create a copy of SearchAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchAnalyticsImplCopyWith<_$SearchAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
