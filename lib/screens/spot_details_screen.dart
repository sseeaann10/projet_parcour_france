import 'package:flutter/material.dart';

class SpotDetailsScreen extends StatelessWidget {
  final Map<String, String> spot;

  SpotDetailsScreen({required this.spot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spot['title']!),
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
