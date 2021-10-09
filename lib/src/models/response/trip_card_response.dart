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
      tripId: json['tripId'],
      tripName: json['tripName'],
      imageUrl: json['imageUrl'],
      startedPoint: json['startedPoint'],
      endedPoint: json['endedPoint'],
      sumOfLocation: json['sumOfLocation'],
      travelingDay: json['travelingDay'],
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
