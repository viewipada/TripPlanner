class LocationDetailResponse {
  final int locationId;
  final double latitude;
  final double longitude;
  final String locationName;
  final String imageUrl;
  final int category;
  final String locationType;
  final String description;
  // final List<String> openingHour;
  final String contactNumber;
  final String website;
  final int duration;
  int? minPrice;
  int? maxPrice;
  final String province;
  final String locationStatus;

  LocationDetailResponse({
    required this.locationId,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.imageUrl,
    required this.category,
    required this.locationType,
    required this.description,
    // required this.openingHour,
    required this.contactNumber,
    required this.website,
    required this.duration,
    this.minPrice,
    this.maxPrice,
    required this.province,
    required this.locationStatus,
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
      // openingHour: json['openingHour'].cast<String>(),
      contactNumber: json['contactNumber'] as String,
      website: json['website'] as String,
      duration: json['duration'] as int,
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
      province: json['province'] as String,
      locationStatus: json['locationStatus'] as String,
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['locationId] = this.locationId;
  //   data['latitude'] = this.latitude;
  //   data['longitude'] = this.longitude;
  //   data['imageUrl'] = this.imageUrl;
  //   data['category'] = this.category;
  //   data['description'] = this.description;
  //   data['openingHour'] = this.openingHour;
  //   data['contactNumber'] = this.contactNumber;
  //   data['website'] = this.website;
  //   data['duration'] = this.duration;
  //   data['averageRating'] = this.averageRating;
  //   data['totalReview'] = this.totalReview;
  //   data['totalCheckin'] = this.totalCheckin;
  //   data['reviews'] = this.reviews.map((v) => v.toJson()).toList();

  //   return data;
  // }
}