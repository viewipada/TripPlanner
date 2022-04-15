class LocationCardResponse {
  final int locationId;
  final String locationName;
  final String username;
  final int category;
  final String locationType;
  final String updateDate;
  final String? status;

  LocationCardResponse({
    required this.locationId,
    required this.locationName,
    required this.username,
    required this.category,
    required this.locationType,
    required this.updateDate,
    required this.status,
  });

  factory LocationCardResponse.fromJson(Map<String, dynamic> json) {
    return LocationCardResponse(
      locationId: json['locationId'] as int,
      locationName: json['locationName'] as String,
      username: json['username'] as String,
      category: json['category'] as int,
      locationType: json['type'] as String,
      updateDate: json['updatedAt'] as String,
      status: json['status'],
    );
  }
}
