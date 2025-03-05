import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import '../widgets/spot_card.dart';
import 'favorites_screen.dart';
import 'spot_details_screen.dart';
import 'publish_spot_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api_service.dart';

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
  List<Spot> spots = [];

  @override
  void initState() {
    super.initState();
    _loadSpots();
  }

  Future<void> _loadSpots() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('spots').get();
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
        spots = loadedSpots;
      });
    } catch (e) {
      print('Erreur lors du chargement des spots: $e');
    }
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
