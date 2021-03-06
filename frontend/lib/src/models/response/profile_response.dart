import 'package:trip_planner/src/models/response/my_review_response.dart';
// import 'package:trip_planner/src/models/response/trip_card_response.dart';

class ProfileResponse {
  final String userImage;
  final String username;
  final String rank;
  final List<MyReviewResponse> reviews;

  ProfileResponse({
    required this.userImage,
    required this.username,
    required this.rank,
    required this.reviews,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    var reviewList = json['reviewers'] as List;

    return ProfileResponse(
      userImage: json['imgUrl'] ??
          "https://cdn.iconscout.com/icon/free/png-256/user-avatar-contact-portfolio-personal-portrait-profile-2-5270.png",
      username: json['username'] as String,
      rank: json['rank'] as String,
      reviews: reviewList.map((i) => MyReviewResponse.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userImage'] = this.userImage;
    data['username'] = this.username;
    data['rank'] = this.rank;
    data['reviews'] = this.reviews.map((v) => v.toJson()).toList();

    return data;
  }
}
