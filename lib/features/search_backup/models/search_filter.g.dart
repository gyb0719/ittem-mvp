// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchFilterImpl _$$SearchFilterImplFromJson(Map<String, dynamic> json) =>
    _$SearchFilterImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$SearchFilterTypeEnumMap, json['type']),
      isActive: json['isActive'] as bool? ?? false,
      value: json['value'],
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => SearchFilterOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      range: json['range'] == null
          ? null
          : SearchFilterRange.fromJson(json['range'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SearchFilterImplToJson(_$SearchFilterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$SearchFilterTypeEnumMap[instance.type]!,
      'isActive': instance.isActive,
      'value': instance.value,
      'options': instance.options,
      'range': instance.range,
      'metadata': instance.metadata,
    };

const _$SearchFilterTypeEnumMap = {
  SearchFilterType.singleSelect: 'single_select',
  SearchFilterType.multiSelect: 'multi_select',
  SearchFilterType.range: 'range',
  SearchFilterType.dateRange: 'date_range',
  SearchFilterType.toggle: 'toggle',
  SearchFilterType.location: 'location',
};

_$SearchFilterOptionImpl _$$SearchFilterOptionImplFromJson(
  Map<String, dynamic> json,
) => _$SearchFilterOptionImpl(
  id: json['id'] as String,
  label: json['label'] as String,
  isSelected: json['isSelected'] as bool? ?? false,
  count: (json['count'] as num?)?.toInt() ?? 0,
  iconUrl: json['iconUrl'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$SearchFilterOptionImplToJson(
  _$SearchFilterOptionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'isSelected': instance.isSelected,
  'count': instance.count,
  'iconUrl': instance.iconUrl,
  'metadata': instance.metadata,
};

_$SearchFilterRangeImpl _$$SearchFilterRangeImplFromJson(
  Map<String, dynamic> json,
) => _$SearchFilterRangeImpl(
  min: (json['min'] as num).toDouble(),
  max: (json['max'] as num).toDouble(),
  currentMin: (json['currentMin'] as num).toDouble(),
  currentMax: (json['currentMax'] as num).toDouble(),
  step: (json['step'] as num?)?.toDouble() ?? 1.0,
  unit: json['unit'] as String?,
  formatter: json['formatter'] as String?,
);

Map<String, dynamic> _$$SearchFilterRangeImplToJson(
  _$SearchFilterRangeImpl instance,
) => <String, dynamic>{
  'min': instance.min,
  'max': instance.max,
  'currentMin': instance.currentMin,
  'currentMax': instance.currentMax,
  'step': instance.step,
  'unit': instance.unit,
  'formatter': instance.formatter,
};

_$SearchFilterPresetImpl _$$SearchFilterPresetImplFromJson(
  Map<String, dynamic> json,
) => _$SearchFilterPresetImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  filters: (json['filters'] as List<dynamic>)
      .map((e) => SearchFilter.fromJson(e as Map<String, dynamic>))
      .toList(),
  description: json['description'] as String?,
  iconUrl: json['iconUrl'] as String?,
  isDefault: json['isDefault'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  lastUsed: json['lastUsed'] == null
      ? null
      : DateTime.parse(json['lastUsed'] as String),
);

Map<String, dynamic> _$$SearchFilterPresetImplToJson(
  _$SearchFilterPresetImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'filters': instance.filters,
  'description': instance.description,
  'iconUrl': instance.iconUrl,
  'isDefault': instance.isDefault,
  'createdAt': instance.createdAt?.toIso8601String(),
  'lastUsed': instance.lastUsed?.toIso8601String(),
};
