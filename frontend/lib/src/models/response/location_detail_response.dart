import 'package:trip_planner/src/models/response/review_response.dart';

class LocationDetailResponse {
  final int locationId;
  final double latitude;
  final double longitude;
  final String locationName;
  final String imageUrl;
  final int category;
  final String description;
  // final String openingHour;
  final String contactNumber;
  final String website;
  final int duration;
  final double averageRating;
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
    // required this.openingHour,
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
      locationId: json['locationId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      locationName: json['locationName'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      description: json['description'],
      // openingHour: json['openingHour'],
      contactNumber: json['contactNumber'],
      website: json['website'],
      duration: json['duration'],
      averageRating: json['averageRating'].toDouble(),
      totalReview: json['totalReview'],
      totalCheckin: json['totalCheckin'],
      reviews: reviewList.map((i) => ReviewResponse.fromJson(i)).toList(),
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
