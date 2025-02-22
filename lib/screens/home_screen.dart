import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import '../widgets/spot_card.dart';

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
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class HomeContentScreen extends StatelessWidget {
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

  HomeContentScreen({super.key});

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
          );
        },
      ),
    );
  }
}
