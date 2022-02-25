class LocationRecommendResponse {
  final int locationId;
  final String locationName;
  final String imageUrl;
  final double rating;
  final int distance;
  final double latitude;
  final double longitude;
  final String category;
  final int duration;

  LocationRecommendResponse({
    required this.locationId,
    required this.locationName,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.duration,
  });

  factory LocationRecommendResponse.fromJson(Map<String, dynamic> json) {
    return LocationRecommendResponse(
      locationId: json['locationId'] ?? 0,
      locationName: json['locationName'],
      imageUrl: json['imageUrl'],
      rating: json['rating'] ?? 0,
      distance: json['distance'],
      latitude: json['latitude'] ?? 0,
      longitude: json['longitude'] ?? 0,
      category: json['category'],
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    data['imageUrl'] = this.imageUrl;
    data['rating'] = this.rating;
    data['distance'] = this.distance;
    return data;
  }
}
