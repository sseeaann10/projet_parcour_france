import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import '../widgets/spot_card.dart';
import 'favorites_screen.dart';
import 'spot_details_screen.dart';
import '../models/spot_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContentScreen(),
    SearchScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue, // Couleur de l'onglet sélectionné
        unselectedItemColor: Colors.grey, // Couleur des autres onglets
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class HomeContentScreen extends StatefulWidget {
  @override
  _HomeContentScreenState createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  final List<Map<String, String>> spots = [
    {
      'title': 'Spot 1',
      'description': 'Un endroit magnifique pour se détendre.',
      'image':
          'https://www.salzburg.info/deskline/infrastruktur/objekte/zoo-salzburg-hellbrunn_4106/image-thumb__909277__slider-main/Familie%20Wei%C3%9Fhandgibbon_29519656.jpg',
    },
    {
      'title': 'Spot 2',
      'description': 'Parfait pour les amateurs de nature.',
      'image':
          'https://picardie.media.tourinsoft.eu/upload/parcsaintpierre8-amiens-somme-picardie.JPG',
    },
  ];

  final List<Spot> favorites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spots à proximité'),
      ),
      body: ListView.builder(
        itemCount: spots.length,
        itemBuilder: (context, index) {
          return SpotCard(
            title: spots[index]['title']!,
            description: spots[index]['description']!,
            imageUrl: spots[index]['image']!,
            onTap: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (context) => SpotDetailsScreen(
                    spot: Spot(
                      id: 0,
                      title: spots[index]['title']!,
                      description: spots[index]['description']!,
                      image: spots[index]['image']!,
                      distance: 0.0,
                      category: 'Non catégorisé',
                    ),
                    onAddToFavorites: (spot) {
                      setState(() {
                        favorites.add(spot);
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
