import 'dart:convert';
import 'package:http/http.dart' as http;

class Spot {
  final String id;
  final String userId;
  final double rating;
  final String title;
  final String description;
  final String image;
  final double distance;
  final String category;
  final String city;
  final double latitude;
  final double longitude;

  Spot({
    required this.id,
    required this.userId,
    required this.rating,
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
      userId: json['userId'],
      rating: json['rating'].toDouble(),
      title: json['title'],
      description: json['description'],
      image: json['image'],
      distance: json['distance'].toDouble(),
      category: json['category'],
      city: json['city'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
}

class ApiService {
  Future<List<Spot>> getSpots() async {
    final response = await http.get(Uri.parse('https://api.example.com/spots'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Spot.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load spots');
    }
  }
}
