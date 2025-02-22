import 'package:flutter/material.dart';

class SpotDetailsScreen extends StatelessWidget {
  final Map<String, String> spot;
  final Function(Map<String, String>) onAddToFavorites;

  const SpotDetailsScreen({
    Key? key,
    required this.spot,
    required this.onAddToFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spot['title']!),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => onAddToFavorites(spot),
          ),
        ],
      ),
      body: Column(
        children: [
          Image.network(spot['image']!),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(spot['description']!),
          ),
        ],
      ),
    );
  }
}
