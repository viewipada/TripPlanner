class Trip {
  int? tripId;
  String tripName;
  String? trumbnail;
  String? vehicle;
  String firstLocation;
  String lastLocation;
  int totalPeople;
  int totalDay;
  int totalTripItem;
  DateTime? startDate;
  Trip({
    this.tripId,
    required this.tripName,
    this.trumbnail,
    this.vehicle,
    required this.firstLocation,
    required this.lastLocation,
    required this.totalPeople,
    required this.totalDay,
    required this.totalTripItem,
    this.startDate,
  });
  factory Trip.fromMap(Map<String, dynamic> json) {
    return Trip(
      tripId: json['tripId'] ?? 0,
      tripName: json['tripName'],
      trumbnail: json['trumbnail'],
      vehicle: json['vehicle'],
      firstLocation: json['firstLocation'],
      lastLocation: json['lastLocation'],
      totalPeople: json['totalPeople'],
      totalDay: json['totalDay'],
      totalTripItem: json['totalTripItem'],
      startDate: json['startDate'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'tripName': tripName,
      'trumbnail': trumbnail,
      'vehicle': vehicle,
      'firstLocation': firstLocation,
      'lastLocation': lastLocation,
      'totalPeople': totalPeople,
      'totalDay': totalDay,
      'totalTripItem': totalTripItem,
      'startDate': startDate,
    };

    return map;
  }
}
