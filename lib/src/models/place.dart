class Place {
  final int id;
  final String name;
  final String imageUrl;
  final String description;

  Place({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        id: json['id'],
        name: json['name'],
        imageUrl: json['imageUrl'],
        description: json['description']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['description'] = this.description;
    return data;
  }
}
