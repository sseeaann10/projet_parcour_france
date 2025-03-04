import 'review_model.dart';

class Spot {
  final String id;
  final String userId;
  final double rating;
  final String title;
  final String description;
  final List<String> images;
  final String address;
  final String category;
  final String city;
  final double latitude;
  final double longitude;
  final List<Review> reviews;

  Spot({
    required this.id,
    required this.userId,
    required this.rating,
    required this.title,
    required this.description,
    required this.images,
    required this.address,
    required this.category,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.reviews = const [],
  });

  factory Spot.fromMap(Map<String, dynamic> map) {
    return Spot(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      address: map['address'] ?? '',
      category: map['category'] ?? '',
      city: map['city'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      reviews: (map['reviews'] as List<dynamic>?)
              ?.map((review) => Review.fromMap(review))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'rating': rating,
      'title': title,
      'description': description,
      'images': images,
      'address': address,
      'category': category,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'reviews': reviews.map((review) => review.toMap()).toList(),
    };
  }

  double calculateAverageRating() {
    if (reviews.isEmpty) return 0.0;
    final sum = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return sum / reviews.length;
  }

  Spot copyWith({
    String? id,
    String? userId,
    double? rating,
    String? title,
    String? description,
    List<String>? images,
    String? address,
    String? category,
    String? city,
    double? latitude,
    double? longitude,
    List<Review>? reviews,
  }) {
    return Spot(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      address: address ?? this.address,
      category: category ?? this.category,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reviews: reviews ?? this.reviews,
    );
  }
}

// Données statiques
final List<Spot> staticSpots = [
  Spot(
    id: '1',
    userId: 'user1',
    rating: 4.5,
    title: 'Tour Eiffel',
    description: 'Le monument le plus emblématique de Paris',
    images: ['https://picsum.photos/200/300'],
    address: 'Champ de Mars, 5 Avenue Anatole France, 75007 Paris',
    category: 'Monuments',
    city: 'Paris',
    latitude: 48.8584,
    longitude: 2.2945,
  ),
  Spot(
    id: '2',
    userId: 'user1',
    rating: 4.8,
    title: 'Mont Saint-Michel',
    description: 'Une merveille architecturale en Normandie',
    images: ['https://picsum.photos/200/300'],
    address: 'Le Mont-Saint-Michel, 50170, France',
    category: 'Monuments',
    city: 'Le Mont-Saint-Michel',
    latitude: 48.6361,
    longitude: -1.5115,
  ),
  Spot(
    id: '3',
    userId: 'user2',
    rating: 4.3,
    title: 'Château de Chambord',
    description: 'Le plus grand château de la Loire',
    images: ['https://picsum.photos/200/300'],
    address: 'Chambord, 41250, France',
    category: 'Châteaux',
    city: 'Chambord',
    latitude: 47.6169,
    longitude: 1.5174,
  ),
  Spot(
    id: '4',
    userId: 'user2',
    rating: 4.7,
    title: 'Gorges du Verdon',
    description: 'Le plus grand canyon d\'Europe',
    images: ['https://picsum.photos/200/300'],
    address: 'Castellane, 04200, France',
    category: 'Nature',
    city: 'Castellane',
    latitude: 43.7469,
    longitude: 6.3774,
  ),
  Spot(
    id: '5',
    userId: 'user3',
    rating: 4.6,
    title: 'Cathédrale de Strasbourg',
    description: 'Chef-d\'œuvre de l\'architecture gothique',
    images: ['https://picsum.photos/200/300'],
    address: 'Place du Marché aux Fleurs, 67000 Strasbourg, France',
    category: 'Monuments',
    city: 'Strasbourg',
    latitude: 48.5818,
    longitude: 7.7509,
  ),
  Spot(
    id: '6',
    userId: 'user3',
    rating: 4.4,
    title: 'Dune du Pilat',
    description: 'La plus haute dune de sable d\'Europe',
    images: ['https://picsum.photos/200/300'],
    address: 'La Teste-de-Buch, 33290, France',
    category: 'Nature',
    city: 'La Teste-de-Buch',
    latitude: 44.5892,
    longitude: -1.2137,
  ),
  Spot(
    id: '7',
    userId: 'user1',
    rating: 4.9,
    title: 'Aiguille du Midi',
    description: 'Point de vue exceptionnel sur le Mont Blanc',
    images: ['https://picsum.photos/200/300'],
    address: 'Chamonix-Mont-Blanc, 74400, France',
    category: 'Nature',
    city: 'Chamonix',
    latitude: 45.8792,
    longitude: 6.8876,
  ),
];
