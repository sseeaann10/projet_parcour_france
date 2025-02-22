import 'package:flutter/material.dart';
import '../models/spot.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

/*class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Rechercher un spot ou un événement',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
      body: Center(
        child: _searchQuery.isEmpty
            ? Text('Entrez une recherche')
            : Text('Résultats pour "$_searchQuery"'),
      ),
    );
  }
}*/

class _SearchScreenState extends State<SearchScreen> {
  // Liste complète des spots (simulée pour l'exemple)
  final List<Spot> allSpots = [
    Spot(
      id: 1,
      title: 'Spot 1',
      description: 'Un endroit magnifique pour se détendre.',
      image:
          'https://www.salzburg.info/deskline/infrastruktur/objekte/zoo-salzburg-hellbrunn_4106/image-thumb__909277__slider-main/Familie%20Wei%C3%9Fhandgibbon_29519656.jpg',
      category: 'Nature',
      distance: 10.0,
    ),
    Spot(
      id: 2,
      title: 'Spot 2',
      description: 'Parfait pour les amateurs de nature.',
      image:
          'https://www.salzburg.info/deskline/infrastruktur/objekte/zoo-salzburg-hellbrunn_4106/image-thumb__909277__slider-main/Familie%20Wei%C3%9Fhandgibbon_29519656.jpg',
      category: 'Sport',
      distance: 17.0,
    ),
    Spot(
      id: 3,
      title: 'Spot 3',
      description: 'Un lieu historique à ne pas manquer.',
      image:
          'https://www.salzburg.info/deskline/infrastruktur/objekte/zoo-salzburg-hellbrunn_4106/image-thumb__909277__slider-main/Familie%20Wei%C3%9Fhandgibbon_29519656.jpg',
      category: 'Histoire',
      distance: 15.0,
    ),
  ];

  // Liste des spots filtrés
  List<Spot> filteredSpots = [];

  // Contrôleur pour le champ de recherche
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'Toutes';
  double _selectedDistance = 20.0;

  final List<String> _categories = ['Toutes', 'Nature', 'Sport', 'Histoire'];

  // Fonction pour filtrer les spots
  void _filterSpots(String query) {
    setState(() {
      if (query.isEmpty &&
          _selectedCategory == 'Toutes' &&
          _selectedDistance == 20.0) {
        // Si la recherche est vide, affiche tous les spots
        filteredSpots = allSpots;
      } else {
        // Sinon, filtre les spots dont le titre ou la description contient le mot-clé
        filteredSpots = allSpots
            .where((spot) =>
                spot.title.toLowerCase().contains(query.toLowerCase()) ||
                spot.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialise la liste filtrée avec tous les spots au démarrage
    filteredSpots = allSpots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Rechercher un spot...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _filterSpots(''); // Réinitialise la recherche
              },
            ),
          ),
          onChanged: _filterSpots, // Appelle _filterSpots à chaque saisie
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                      _filterSpots(_searchController.text);
                    });
                  },
                  items:
                      _categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 16.0),
                Text(
                    'Distance maximale: $_selectedDistance.toStringAsFixed(1) km'),
                Slider(
                  value: _selectedDistance,
                  min: 0.0,
                  max: 2.0,
                  divisions: 20,
                  label: _selectedDistance.toStringAsFixed(1),
                  onChanged: (double value) {
                    setState(() {
                      _selectedDistance = value;
                      _filterSpots(_searchController.text);
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredSpots.isEmpty
                ? Center(
                    child: Text(
                      'Aucun résultat trouvé.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredSpots.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.network(filteredSpots[index].image),
                          title: Text(filteredSpots[index].title),
                          subtitle: Text(
                              '${filteredSpots[index].description}\n${filteredSpots[index].distance} km'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
