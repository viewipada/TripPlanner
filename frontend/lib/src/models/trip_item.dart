class TripItem {
  int? itemId;
  int day;
  int no;
  int locationId;
  String locationCategory;
  String locationName;
  String imageUrl;
  double latitude;
  double longitude;
  String? startTime;
  double? distance;
  int duration;
  int? drivingDuration;
  String? note;
  int tripId;

  TripItem({
    this.itemId,
    required this.day,
    required this.no,
    required this.locationId,
    required this.locationCategory,
    required this.locationName,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.startTime,
    this.distance,
    required this.duration,
    this.drivingDuration,
    this.note,
    required this.tripId,
  });

  factory TripItem.fromMap(Map<String, dynamic> json) {
    return TripItem(
      itemId: json['itemId'] ?? 0,
      day: json['day'] as int,
      no: json['no'] as int,
      locationId: json['locationId'] as int,
      locationCategory: json['locationCategory'] as String,
      locationName: json['locationName'] as String,
      imageUrl: json['imageUrl'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      startTime: json['startTime'],
      distance: json['distance'],
      duration: json['duration'] as int,
      drivingDuration: json['drivingDuration'],
      note: json['note'],
      tripId: json['FK_tripItem_trip'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'day': day,
      'no': no,
      'locationId': locationId,
      'locationCategory': locationCategory,
      'locationName': locationName,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'startTime': startTime,
      'distance': distance,
      'duration': duration,
      'drivingDuration': drivingDuration,
      'note': note,
      'FK_tripItem_trip': tripId,
    };

    return map;
  }
}
