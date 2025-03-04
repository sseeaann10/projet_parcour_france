import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/spot.dart';
import '../providers/spot_provider.dart';
import 'spot_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Spot> favorites = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }

  void _loadFavorites() {
    final spotProvider = Provider.of<SpotProvider>(context, listen: false);
    setState(() {
      favorites = spotProvider.spots;
    });
  }

  void _removeFavorite(String id) {
    final spotProvider = Provider.of<SpotProvider>(context, listen: false);
    spotProvider.removeSpot(id);
    _loadFavorites();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Spot supprimé des favoris')),
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
                    leading: Image.network(favorites[index].images.first),
                    title: Text(favorites[index].title),
                    subtitle: Text(favorites[index].description),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => _removeFavorite(favorites[index].id),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpotDetailsScreen(
                            spot: favorites[index],
                            onAddToFavorites: (spot) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Ce spot est déjà dans vos favoris')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
