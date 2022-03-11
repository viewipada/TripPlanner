class ShopResponse {
  final int locationId;
  final String locationName;
  final String imageUrl;
  final double rating;
  final double latitude;
  final double longitude;
  final int duration;

  ShopResponse({
    required this.locationId,
    required this.locationName,
    required this.imageUrl,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.duration,
  });

  factory ShopResponse.fromJson(Map<String, dynamic> json) {
    return ShopResponse(
      locationId: json['locationId'] ?? 0,
      locationName: json['locationName'],
      imageUrl: json['imageUrl'],
      rating: json['rating'] ?? 0,
      latitude: json['latitude'] ?? 0,
      longitude: json['longitude'] ?? 0,
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    data['imageUrl'] = this.imageUrl;
    data['rating'] = this.rating;
    return data;
  }
}
