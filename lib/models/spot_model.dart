class Spot {
  final String title;
  final String description;
  final String imageUrl;
  final double distance;
  final String category;

  Spot({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.distance,
    required this.category,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image'],
      distance: json['distance'],
      category: json['category'],
    );
  }
}
