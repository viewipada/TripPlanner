import 'package:trip_planner/src/models/response/my_review_response.dart';
import 'package:trip_planner/src/models/response/trip_card_response.dart';

class ProfileResponse {
  final String userImage;
  final String username;
  // final List<TripCardResponse> trips;
  final List<MyReviewResponse> reviews;

  ProfileResponse({
    required this.userImage,
    required this.username,
    // required this.trips,
    required this.reviews,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    var reviewList = json['reviews'] as List;
    // var tripList = json['trips'] as List;

    return ProfileResponse(
      userImage: json['userImage'],
      username: json['username'],
      // trips: tripList.map((i) => TripCardResponse.fromJson(i)).toList(),
      reviews: reviewList.map((i) => MyReviewResponse.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userImage'] = this.userImage;
    data['username'] = this.username;
    // data['trips'] = this.trips.map((v) => v.toMap()).toList();
    data['reviews'] = this.reviews.map((v) => v.toJson()).toList();

    return data;
  }
}
