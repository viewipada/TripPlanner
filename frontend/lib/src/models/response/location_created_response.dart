class LocationCreatedResponse {
  final int locationId;
  final String locationName;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String category;
  final String description;
  final String locationStatus;

  LocationCreatedResponse({
    required this.locationId,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.locationStatus,
  });

  factory LocationCreatedResponse.fromJson(Map<String, dynamic> json) {
    return LocationCreatedResponse(
      locationId: json['locationId'] as int,
      locationName: json['locationName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      locationStatus: json['locationStatus'] as String,
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
    data['locationStatus'] = this.locationStatus;
    return data;
  }
}
