import 'package:flutter/material.dart';
import '../models/spot_model.dart';

class SpotDetailsScreen extends StatelessWidget {
  final Spot spot;
  final Function(Spot) onAddToFavorites;

  SpotDetailsScreen({
    required this.spot,
    required this.onAddToFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spot.title),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => onAddToFavorites(spot),
          ),
        ],
      ),
      body: Column(
        children: [
          Image.network(spot.image),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(spot.description),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Catégorie : ${spot.category}'),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Distance : ${spot.distance} km'),
          ),
        ],
      ),
    );
  }
}
