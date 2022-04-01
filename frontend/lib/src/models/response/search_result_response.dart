import 'package:json_annotation/json_annotation.dart';

part "search_result_response.g.dart";

@JsonSerializable(explicitToJson: true)
class SearchResultResponse {
  int locationId;
  String locationName;
  String imageUrl;
  String description;
  int category;
  double rating;
  int totalCheckin;

  SearchResultResponse({
    required this.locationId,
    required this.locationName,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.rating,
    required this.totalCheckin,
  });

  factory SearchResultResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResultResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultResponseToJson(this);
}
