class UserInterestedResponse {
  final int userId;
  final String? firstActivity;
  final String? secondActivity;
  final String? thirdActivity;
  final String? firstFood;
  final String? secondFood;
  final String? thirdFood;
  final String? firstHotel;
  final String? secondHotel;
  final String? thirdHotel;
  final int? minPrice;
  final int? maxPrice;

  UserInterestedResponse({
    required this.userId,
    this.firstActivity,
    this.secondActivity,
    this.thirdActivity,
    this.firstFood,
    this.secondFood,
    this.thirdFood,
    this.firstHotel,
    this.secondHotel,
    this.thirdHotel,
    this.minPrice,
    this.maxPrice,
  });

  factory UserInterestedResponse.fromJson(Map<String, dynamic> json) {
    return UserInterestedResponse(
      userId: json['userId'] as int,
      firstActivity: json['first_activity'],
      secondActivity: json['second_activity'],
      thirdActivity: json['third_activity'],
      firstFood: json['first_food'],
      secondFood: json['second_food'],
      thirdFood: json['third_food'],
      firstHotel: json['first_hotel'],
      secondHotel: json['second_hotel'],
      thirdHotel: json['third_hotel'],
      minPrice: json['min_price'],
      maxPrice: json['max_price'],
    );
  }
}
