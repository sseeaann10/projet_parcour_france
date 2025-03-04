class Review {
  final String id;
  final String userId;
  final String spotId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.spotId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      spotId: map['spotId'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'spotId': spotId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
