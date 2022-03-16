class LocationRecommendResponse {
  final int locationId;
  final String locationName;
  final String imageUrl;
  final double rating;
  final double distance;
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
      locationId: json['locationId'] as int,
      locationName: json['locationName'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      category: json['category'] as String,
      duration: json['duration'] as int,
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
