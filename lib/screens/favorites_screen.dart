import 'package:flutter/material.dart';
import '../db/database.dart';
import 'spot_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late AppDatabase database;
  List<Spot> favorites = [];

  @override
  void initState() {
    super.initState();
    database = AppDatabase();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    // TODO: Implémenter le chargement des favoris depuis la base de données
    final spots = await database.allSpots;
    setState(() {
      favorites = spots;
    });
  }

  void _removeFavorite(int id) async {
    await database.deleteSpot(id);
    _loadFavorites();
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
