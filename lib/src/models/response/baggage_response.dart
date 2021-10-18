class BaggageResponse {
  final int locationId;
  final String locationName;
  final String imageUrl;
  final String category;
  final String description;

  BaggageResponse({
    required this.locationId,
    required this.locationName,
    required this.imageUrl,
    required this.category,
    required this.description,
  });

  factory BaggageResponse.fromJson(Map<String, dynamic> json) {
    return BaggageResponse(
      locationId: json['locationId'],
      locationName: json['locationName'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationId'] = this.locationId;
    data['locationName'] = this.locationName;
    data['imageUrl'] = this.imageUrl;
    data['category'] = this.category;
    data['description'] = this.description;
    return data;
  }
}
