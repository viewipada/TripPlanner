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
        locationId: json['locationId'],
        locationName: json['locationName'],
        imageUrl: json['imageUrl']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
