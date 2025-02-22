import 'package:flutter/material.dart';
import '../models/spot.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Spot> favorites = [
    Spot(
      id: 1,
      title: 'Spot 1',
      description: 'Description du spot 1',
      image:
          'https://www.salzburg.info/deskline/infrastruktur/objekte/zoo-salzburg-hellbrunn_4106/image-thumb__909277__slider-main/Familie%20Wei%C3%9Fhandgibbon_29519656.jpg',
      distance: 10.0,
      category: 'Nature',
    ),
    Spot(
      id: 2,
      title: 'Spot 2',
      description: 'Description du spot 2',
      image:
          'https://www.salzburg.info/deskline/infrastruktur/objekte/zoo-salzburg-hellbrunn_4106/image-thumb__909277__slider-main/Familie%20Wei%C3%9Fhandgibbon_29519656.jpg',
      distance: 15.0,
      category: 'Sport',
    ),
  ];

  void _removeFavorite(int index) {
    setState(() {
      favorites.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Spot supprimé des favoris'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoris'),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Text('Aucun favori trouvé'),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(favorites[index].image),
                    title: Text(favorites[index].title),
                    subtitle: Text(favorites[index].description),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => _removeFavorite(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
