class LocationCardResponse {
  final int locationId;
  final String locationName;
  // final String username;
  final int category;
  final String locationType;
  final String updateDate;

  LocationCardResponse({
    required this.locationId,
    required this.locationName,
    // required this.username,
    required this.category,
    required this.locationType,
    required this.updateDate,
  });

  factory LocationCardResponse.fromJson(Map<String, dynamic> json) {
    return LocationCardResponse(
        locationId: json['locationId'] as int,
        locationName: json['locationName'] as String,
        // username: json['username'] as String,
        category: json['category'] as int,
        locationType: json['type'] as String,
        updateDate: json['updatedAt'] as String);
  }

  // Map<String, dynamic> toMap() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['locationId'] = this.locationId;
  //   data['locationName'] = this.locationName;
  //   data['imageUrl'] = this.imageUrl;
  //   return data;
  // }
}
