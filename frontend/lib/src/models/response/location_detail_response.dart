import 'package:trip_planner/src/models/response/opening_hour.dart';
import 'package:trip_planner/src/models/response/review_response.dart';

class LocationDetailResponse {
  final int locationId;
  final double latitude;
  final double longitude;
  final String locationName;
  final String imageUrl;
  final int category;
  final String description;
  final OpeningHour openingHour;
  final String contactNumber;
  final String website;
  final int duration;
  final String averageRating;
  final int totalReview;
  final int totalCheckin;
  final List<ReviewResponse> reviews;

  LocationDetailResponse({
    required this.locationId,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.openingHour,
    required this.contactNumber,
    required this.website,
    required this.duration,
    required this.averageRating,
    required this.totalReview,
    required this.totalCheckin,
    required this.reviews,
  });

  factory LocationDetailResponse.fromJson(Map<String, dynamic> json) {
    var reviewList = json['reviewers'] as List;

    return LocationDetailResponse(
      locationId: json['locationId'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      locationName: json['locationName'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as int,
      description: json['description'] as String,
      openingHour: OpeningHour.fromMap(json['openingHour']),
      contactNumber: json['contactNumber'] as String,
      website: json['website'] as String,
      duration: json['duration'] as int,
      averageRating: json['averageRating'] as String,
      totalReview: json['totalReview'] as int,
      totalCheckin: json['totalCheckin'] as int,
      reviews: reviewList.map((i) => ReviewResponse.fromJson(i)).toList(),
    );
  }
}
