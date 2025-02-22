class Spot {
  final int id;
  final String title;
  final String description;
  final String image;
  final double distance;
  final String category;

  Spot({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.distance,
    required this.category,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      distance: json['distance'],
      category: json['category'],
    );
  }
}
