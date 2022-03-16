class LocationCardResponse {
  final int locationId;
  final String locationName;
  final String imageUrl;

  LocationCardResponse({
    required this.locationId,
    required this.locationName,
    required this.imageUrl,
  });

  factory LocationCardResponse.fromJson(Map<String, dynamic> json) {
    return LocationCardResponse(
      locationId: json['locationId'] ?? 0,
      locationName: json['locationName'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
