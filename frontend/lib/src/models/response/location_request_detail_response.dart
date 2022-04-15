import 'package:trip_planner/src/models/response/opening_hour.dart';

class LocationRequestDetailResponse {
  final int locationId;
  final double latitude;
  final double longitude;
  final String locationName;
  final String imageUrl;
  final int category;
  final String locationType;
  final String description;
  final OpeningHour openingHour;
  final String contactNumber;
  final String website;
  // final int duration;
  final String province;
  final int? minPrice;
  final int? maxPrice;

  LocationRequestDetailResponse({
    required this.locationId,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.imageUrl,
    required this.category,
    required this.locationType,
    required this.description,
    required this.openingHour,
    required this.contactNumber,
    required this.website,
    // required this.duration,
    required this.province,
    this.maxPrice,
    this.minPrice,
  });

  factory LocationRequestDetailResponse.fromJson(Map<String, dynamic> json) {
    return LocationRequestDetailResponse(
      locationId: json['locationId'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      locationName: json['locationName'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as int,
      locationType: json['type'] as String,
      description: json['description'] as String,
      openingHour: OpeningHour.fromMap(json['openingHour']),
      contactNumber: json['contactNumber'] as String,
      website: json['website'] as String,
      // duration: json['duration'] as int,
      province: json['province'] as String,
      minPrice: json['min_price'],
      maxPrice: json['max_price'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['locationId] = this.locationId;
  //   data['latitude'] = this.latitude;
  //   data['longitude'] = this.longitude;
  //   data['imageUrl'] = this.imageUrl;
  //   data['category'] = this.category;
  //   data['description'] = this.description;
  //   data['openingHour'] = this.openingHour;
  //   data['contactNumber'] = this.contactNumber;
  //   data['website'] = this.website;
  //   data['duration'] = this.duration;
  //   data['averageRating'] = this.averageRating;
  //   data['totalReview'] = this.totalReview;
  //   data['totalCheckin'] = this.totalCheckin;
  //   data['reviews'] = this.reviews.map((v) => v.toJson()).toList();

  //   return data;
  // }
}
