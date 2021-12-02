class MyReviewResponse {
  int locationId;
  String locationName;
  double rating;
  String caption;
  List<String> images;

  MyReviewResponse({
    required this.locationId,
    required this.locationName,
    required this.rating,
    required this.caption,
    required this.images,
  });

  factory MyReviewResponse.fromJson(Map<String, dynamic> json) {
    return MyReviewResponse(
        locationId: json['locationId'],
        locationName: json['locationName'],
        rating: json['rating'],
        caption: json['caption'] ?? '',
        images: json['images'].cast<String>());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    data['rating'] = this.rating;
    data['caption'] = this.caption;
    data['images'] = this.images;
    return data;
  }
}
