import 'package:json_annotation/json_annotation.dart';

part "travel_nearby_response.g.dart";

@JsonSerializable(explicitToJson: true)
class LocationNearbyResponse {
  int locationId;
  String locationName;
  String imageUrl;
  String description;
  double latitude;
  double longitude;
  double ditanceFromeUser;

  LocationNearbyResponse({
    required this.locationId,
    required this.locationName,
    required this.imageUrl,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.ditanceFromeUser,
  });

  factory LocationNearbyResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationNearbyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LocationNearbyResponseToJson(this);
}
