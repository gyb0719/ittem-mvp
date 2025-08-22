import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required String id,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    String? city,
    String? district,
    String? postalCode,
    String? country,
    @Default('KR') String countryCode,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) => 
      _$LocationModelFromJson(json);
}