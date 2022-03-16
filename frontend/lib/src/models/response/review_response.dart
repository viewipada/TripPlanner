class ReviewResponse {
  String profileImage;
  String username;
  int rating;
  String caption;
  List<String> images;
  String createdDate;

  ReviewResponse({
    required this.profileImage,
    required this.username,
    required this.rating,
    required this.caption,
    required this.images,
    required this.createdDate,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      profileImage: json['profileImage'] as String,
      username: json['username'] as String,
      rating: json['rating'] as int,
      caption: json['caption'] as String,
      images: json['images'].cast<String>(),
      createdDate: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileImage'] = this.profileImage;
    data['username'] = this.username;
    data['rating'] = this.rating;
    data['caption'] = this.caption;
    data['images'] = this.images;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
