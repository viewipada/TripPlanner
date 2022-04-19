class LocationDetailResponse {
  final int locationId;
  final double latitude;
  final double longitude;
  final String locationName;
  final String imageUrl;
  final int category;
  final String locationType;
  final String description;
  final OpeningHour openingHour;
  final String contactNumber;
  final String website;
  final int duration;
  int? minPrice;
  int? maxPrice;
  final String province;
  final String locationStatus;
  final String? remark;

  LocationDetailResponse({
    required this.locationId,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.imageUrl,
    required this.category,
    required this.locationType,
    required this.description,
    required this.openingHour,
    required this.contactNumber,
    required this.website,
    required this.duration,
    this.minPrice,
    this.maxPrice,
    required this.province,
    required this.locationStatus,
    this.remark,
  });

  factory LocationDetailResponse.fromJson(Map<String, dynamic> json) {
    return LocationDetailResponse(
      locationId: json['locationId'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      locationName: json['locationName'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as int,
      locationType: json['type'] as String,
      description: json['description'] as String,
      openingHour: OpeningHour.fromMap(json['openingHour']),
      contactNumber: json['contactNumber'] as String,
      website: json['website'] as String,
      duration: json['duration'] as int,
      minPrice: json['min_price'],
      maxPrice: json['max_price'],
      province: json['province'] as String,
      locationStatus: json['locationStatus'] as String,
      remark: json['remark'],
    );
  }
}

class OpeningHour {
  final String mon;
  final String tue;
  final String wed;
  final String thu;
  final String fri;
  final String sat;
  final String sun;

  OpeningHour({
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
    required this.sat,
    required this.sun,
  });

  factory OpeningHour.fromMap(Map<String, dynamic> json) {
    return OpeningHour(
      mon: json['mon'] as String,
      tue: json['tue'] as String,
      wed: json['wed'] as String,
      thu: json['thu'] as String,
      fri: json['fri'] as String,
      sat: json['sat'] as String,
      sun: json['sun'] as String,
    );
  }
}
