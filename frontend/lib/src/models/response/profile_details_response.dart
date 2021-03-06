class ProfileDetailsResponse {
  final String userImage;
  final String username;
  final String gender;
  final String birthdate;
  final String rank;

  ProfileDetailsResponse({
    required this.userImage,
    required this.username,
    required this.gender,
    required this.birthdate,
    required this.rank,
  });

  factory ProfileDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProfileDetailsResponse(
      userImage: json['imgUrl'] ??
          "https://cdn.iconscout.com/icon/free/png-256/user-avatar-contact-portfolio-personal-portrait-profile-2-5270.png",
      username: json['username'] as String,
      gender: json['gender'] as String,
      birthdate: json['birthDate'] as String,
      rank: json['rank'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userImage'] = this.userImage;
    data['username'] = this.username;
    data['gender'] = this.gender;
    data['birthdate'] = this.birthdate;
    data['rank'] = this.rank;

    return data;
  }
}
