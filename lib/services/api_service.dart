import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/spot_model.dart';

class ApiService {
  Future<List<Spot>> getSpots() async {
    final response = await http.get(Uri.parse('https://api.example.com/spots'));
    if (response.statusCode == 200) {
      List<dynamic> spots = jsonDecode(response.body);
      return spots.map((json) => Spot.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load spots');
    }
  }
}
