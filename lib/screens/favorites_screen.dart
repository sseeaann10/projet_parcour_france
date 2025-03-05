import 'package:flutter/material.dart';
import 'spot_details_screen.dart';
import '../services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Spot> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: authProvider.userId)
          .get();

      final loadedSpots = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Spot(
          id: doc.id,
          userId: data['userId'] ?? '',
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          image: data['image'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          distance: (data['distance'] ?? 0).toDouble(),
          category: data['category'] ?? '',
          city: data['city'] ?? '',
          latitude: (data['latitude'] ?? 0).toDouble(),
          longitude: (data['longitude'] ?? 0).toDouble(),
        );
      }).toList();

      setState(() {
        favorites = loadedSpots;
      });
    } catch (e) {
      print('Erreur lors du chargement des favoris: $e');
    }
  }

  void _removeFavorite(String id) async {
    try {
      await FirebaseFirestore.instance.collection('favorites').doc(id).delete();
      _loadFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Spot supprimé des favoris')),
      );
    } catch (e) {
      print('Erreur lors de la suppression du favori: $e');
    }
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
