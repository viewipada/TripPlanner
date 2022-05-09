// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultResponse _$SearchResultResponseFromJson(
        Map<String, dynamic> json) =>
    SearchResultResponse(
      locationId: json['locationId'] as int,
      locationName: json['locationName'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      category: json['category'] as int,
      rating: (json['averageRating'] as num).toDouble(),
      totalCheckin: json['totalCheckin'] as int,
    );

Map<String, dynamic> _$SearchResultResponseToJson(
        SearchResultResponse instance) =>
    <String, dynamic>{
      'locationId': instance.locationId,
      'locationName': instance.locationName,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'category': instance.category,
      'rating': instance.rating,
      'totalCheckin': instance.totalCheckin,
    };
