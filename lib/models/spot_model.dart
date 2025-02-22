class Spot {
  final String title;
  final String description;
  final String imageUrl;

  Spot({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image'],
    );
  }
}
