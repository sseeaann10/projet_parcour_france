import 'package:flutter/material.dart';

class SpotCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const SpotCard({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(imageUrl),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}
