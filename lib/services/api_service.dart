import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/spot.dart';
import '../providers/spot_provider.dart';

class ApiService {
  Future<List<Spot>> getSpots() async {
    final response = await http.get(Uri.parse('https://api.example.com/spots'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => Spot(
                id: json['id'],
                userId: json['userId'],
                rating: json['rating'].toDouble(),
                title: json['title'],
                description: json['description'],
                images: List<String>.from(json['images'] ?? []),
                address: json['address'] ?? '',
                category: json['category'],
                city: json['city'],
                latitude: json['latitude'].toDouble(),
                longitude: json['longitude'].toDouble(),
              ))
          .toList();
    } else {
      throw Exception('Failed to load spots');
    }
  }
}
