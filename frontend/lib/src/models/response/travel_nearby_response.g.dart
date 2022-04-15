// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_nearby_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationNearbyResponse _$LocationNearbyResponseFromJson(
        Map<String, dynamic> json) =>
    LocationNearbyResponse(
      locationId: json['locationId'] as int,
      locationName: json['locationName'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      category: json['category'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      ditanceFromeUser: (json['ditanceFromeUser'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationNearbyResponseToJson(
        LocationNearbyResponse instance) =>
    <String, dynamic>{
      'locationId': instance.locationId,
      'locationName': instance.locationName,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'category': instance.category,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'ditanceFromeUser': instance.ditanceFromeUser,
    };
