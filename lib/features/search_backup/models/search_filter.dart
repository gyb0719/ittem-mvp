import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filter.freezed.dart';
part 'search_filter.g.dart';

@freezed
class SearchFilter with _$SearchFilter {
  const factory SearchFilter({
    required String id,
    required String name,
    required SearchFilterType type,
    @Default(false) bool isActive,
    dynamic value,
    List<SearchFilterOption>? options,
    SearchFilterRange? range,
    Map<String, dynamic>? metadata,
  }) = _SearchFilter;

  factory SearchFilter.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterFromJson(json);
}

enum SearchFilterType {
  @JsonValue('single_select')
  singleSelect,   // 단일 선택 (라디오)
  @JsonValue('multi_select')
  multiSelect,    // 다중 선택 (체크박스)
  @JsonValue('range')
  range,          // 범위 선택 (슬라이더)
  @JsonValue('date_range')
  dateRange,      // 날짜 범위
  @JsonValue('toggle')
  toggle,         // 토글 (스위치)
  @JsonValue('location')
  location,       // 위치 선택
}

@freezed
class SearchFilterOption with _$SearchFilterOption {
  const factory SearchFilterOption({
    required String id,
    required String label,
    @Default(false) bool isSelected,
    @Default(0) int count,
    String? iconUrl,
    Map<String, dynamic>? metadata,
  }) = _SearchFilterOption;

  factory SearchFilterOption.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterOptionFromJson(json);
}

@freezed
class SearchFilterRange with _$SearchFilterRange {
  const factory SearchFilterRange({
    required double min,
    required double max,
    required double currentMin,
    required double currentMax,
    @Default(1.0) double step,
    String? unit,
    String? formatter,
  }) = _SearchFilterRange;

  factory SearchFilterRange.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterRangeFromJson(json);
}

@freezed
class SearchFilterPreset with _$SearchFilterPreset {
  const factory SearchFilterPreset({
    required String id,
    required String name,
    required List<SearchFilter> filters,
    String? description,
    String? iconUrl,
    @Default(false) bool isDefault,
    DateTime? createdAt,
    DateTime? lastUsed,
  }) = _SearchFilterPreset;

  factory SearchFilterPreset.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterPresetFromJson(json);
}