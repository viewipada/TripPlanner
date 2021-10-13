class ReviewResponse {
  String profileImage;
  String username;
  double rating;
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
      profileImage: json['profileImage'],
      username: json['username'],
      rating: json['rating'],
      caption: json['caption'] ?? '',
      images: json['images'].cast<String>(),
      createdDate: json['createdDate'],
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
