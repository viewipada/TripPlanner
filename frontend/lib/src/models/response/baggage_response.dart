class BaggageResponse {
  final int locationId;
  final String locationName;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String category;
  final String description;
  final int duration;

  BaggageResponse({
    required this.locationId,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.duration,
  });

  factory BaggageResponse.fromJson(Map<String, dynamic> json) {
    return BaggageResponse(
      locationId: json['locationId'] as int,
      locationName: json['locationName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['imageUrl'] = this.imageUrl;
    data['category'] = this.category;
    data['description'] = this.description;
    data['duration'] = this.duration;
    return data;
  }
}
