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
  String? startDate;
  String status;
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
    required this.status,
  });
  factory Trip.fromMap(Map<String, dynamic> json) {
    return Trip(
      tripId: json['tripId'] ?? 0,
      tripName: json['tripName'] as String,
      trumbnail: json['trumbnail'],
      vehicle: json['vehicle'],
      firstLocation: json['firstLocation'] as String,
      lastLocation: json['lastLocation'] as String,
      totalPeople: json['totalPeople'] as int,
      totalDay: json['totalDay'] as int,
      totalTripItem: json['totalTripItem'] as int,
      startDate: json['startDate'],
      status: json['status'],
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
      'status': status,
    };

    return map;
  }
}
