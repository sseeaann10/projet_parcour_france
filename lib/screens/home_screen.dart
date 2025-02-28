import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import '../widgets/spot_card.dart';
import 'favorites_screen.dart';
import 'spot_details_screen.dart';
import '../db/database.dart';
import 'publish_spot_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

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
    PublishSpotScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isLoggedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PublishSpotScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    }
  }

  void _handleNavigation(int index, BuildContext context) {
    if (index == 2) {
      // Index du bouton "Publier"
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isLoggedIn) {
        // Si l'utilisateur n'est pas connecté, rediriger vers l'écran de connexion
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        return;
      }
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _handleNavigation(index, context),
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
            icon: Icon(Icons.publish),
            label: 'Publié',
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
  late AppDatabase database;
  List<Spot> spots = [];

  @override
  void initState() {
    super.initState();
    database = AppDatabase();
    _loadSpots();
  }

  Future<void> _loadSpots() async {
    final loadedSpots = await database.allSpots;
    setState(() {
      spots = loadedSpots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'mesbonspots',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: spots.isEmpty
          ? Center(
              child: Text('Aucun spot disponible'),
            )
          : ListView.builder(
              itemCount: spots.length,
              itemBuilder: (context, index) {
                final spot = spots[index];
                return SpotCard(
                  title: spot.title,
                  description: spot.description,
                  imageUrl: spot.image,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (context) => SpotDetailsScreen(
                          spot: spot,
                          onAddToFavorites: (spot) async {
                            // Ici, vous pouvez ajouter la logique pour sauvegarder les favoris
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Spot ajouté aux favoris')),
                            );
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
