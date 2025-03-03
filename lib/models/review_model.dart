class Review {
  final String id;
  final String userId;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
