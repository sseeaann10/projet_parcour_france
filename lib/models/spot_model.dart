class Spot {
  final int id;
  final String title;
  final String description;
  final String image;
  double distance;
  final String category;
  final String city;
  final double latitude;
  final double longitude;

  Spot({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.distance,
    required this.category,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        image: json['image'],
        distance: json['distance'],
        category: json['category'],
        city: json['city'],
        latitude: json['latitude'],
        longitude: json['longitude']);
  }
}
