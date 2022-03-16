class TripCardResponse {
  final int tripId;
  final String tripName;
  final String imageUrl;
  final String startedPoint;
  final String endedPoint;
  final int sumOfLocation;
  final int travelingDay;

  TripCardResponse(
      {required this.tripId,
      required this.tripName,
      required this.imageUrl,
      required this.startedPoint,
      required this.endedPoint,
      required this.sumOfLocation,
      required this.travelingDay});

  factory TripCardResponse.fromJson(Map<String, dynamic> json) {
    return TripCardResponse(
      tripId: json['tripId'] as int,
      tripName: json['tripName'] as String,
      imageUrl: json['imageUrl'] as String,
      startedPoint: json['startedPoint'] as String,
      endedPoint: json['endedPoint'] as String,
      sumOfLocation: json['sumOfLocation'] as int,
      travelingDay: json['travelingDay'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tripId'] = this.tripId;
    data['tripName'] = this.tripName;
    data['imageUrl'] = this.imageUrl;
    data['startedPoint'] = this.startedPoint;
    data['endedPoint'] = this.endedPoint;
    data['sumOfLocation'] = this.sumOfLocation;
    data['travelingDay'] = this.travelingDay;
    return data;
  }
}
