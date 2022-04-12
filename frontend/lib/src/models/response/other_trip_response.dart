class OtherTripResponse {
  int tripId;
  String tripName;
  String? trumbnail;
  String firstLocation;
  String lastLocation;
  int totalPeople;
  int totalDay;
  String? startDate;
  String status;

  List<OtherTripItemResponse> tripItems;

  OtherTripResponse({
    required this.tripId,
    required this.tripName,
    this.trumbnail,
    required this.firstLocation,
    required this.lastLocation,
    required this.totalPeople,
    required this.totalDay,
    this.startDate,
    required this.status,
    required this.tripItems,
  });

  factory OtherTripResponse.fromMap(Map<String, dynamic> json) {
    var tripItemList = json['tripItem'] as List;

    return OtherTripResponse(
      tripId: json['id'] as int,
      tripName: json['name'] as String,
      trumbnail: json['trumbnail'],
      firstLocation: json['firstLocation'] as String,
      lastLocation: json['lastLocation'] as String,
      totalPeople: json['totalPeople'] as int,
      totalDay: json['totalDay'] as int,
      startDate: json['startDate'],
      status: json['status'],
      tripItems:
          tripItemList.map((i) => OtherTripItemResponse.fromJson(i)).toList(),
    );
  }
}

class OtherTripItemResponse {
  int tripId;
  int day;
  int no;
  int locationId;
  String locationName;
  String imageUrl;
  double latitude;
  double longitude;
  int locationCategory;
  String startTime;
  double? distance;
  int duration;
  int? drivingDuration;
  String? note;

  OtherTripItemResponse({
    required this.tripId,
    required this.day,
    required this.no,
    required this.locationId,
    required this.locationName,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.locationCategory,
    required this.startTime,
    this.distance,
    required this.duration,
    this.drivingDuration,
    this.note,
  });
  factory OtherTripItemResponse.fromJson(Map<String, dynamic> json) {
    return OtherTripItemResponse(
      tripId: json['tripId'] as int,
      day: json['day'] as int,
      no: json['order'] as int,
      locationId: json['locationId'] as int,
      locationName: json['locationName'] as String,
      imageUrl: json['imageUrl'] as String,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      locationCategory: json['locationCategory'] as int,
      startTime: json['startTime'] as String,
      distance: json['distance'],
      duration: json['duration'],
      drivingDuration: json['drivingDuration'],
      note: json['note'],
    );
  }
}
