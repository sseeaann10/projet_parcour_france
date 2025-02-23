import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Pour la géolocalisation
import 'package:geocoding/geocoding.dart'; // Pour le géocodage
import '../models/spot_model.dart'; // Importe le modèle Spot

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Liste complète des spots (simulée pour l'exemple)
  final List<Spot> allSpots = [
    Spot(
      id: 1,
      title: 'Spot 1',
      description: 'Un endroit magnifique pour se détendre.',
      image:
          'https://monsieurmadameexplore.com/wp-content/uploads/2021/05/Spirit-Island_3.jpg',
      category: 'Nature',
      distance: 0.0, // La distance sera calculée dynamiquement
      city: 'Paris',
      latitude: 48.8566,
      longitude: 2.3522,
    ),
    Spot(
      id: 2,
      title: 'Spot 2',
      description: 'Parfait pour les amateurs de nature.',
      image:
          'https://odysseedelaterre.fr/wp-content/uploads/2024/09/plus-haute-montagne-monde.jpg',
      category: 'Nature',
      distance: 0.0, // La distance sera calculée dynamiquement
      city: 'Lyon',
      latitude: 45.7640,
      longitude: 4.8357,
    ),
    Spot(
      id: 3,
      title: 'Spot 3',
      description: 'Un lieu historique à ne pas manquer.',
      image:
          'https://monsieurmadameexplore.com/wp-content/uploads/2021/05/Spirit-Island_3.jpg',
      category: 'Histoire',
      distance: 0.0, // La distance sera calculée dynamiquement
      city: 'Marseille',
      latitude: 43.2965,
      longitude: 5.3698,
    ),
  ];

  // Liste des spots filtrés
  List<Spot> filteredSpots = [];

  // Contrôleur pour le champ de recherche
  final TextEditingController _searchController = TextEditingController();

  // Filtres temporaires (visuels)
  String _tempCategory = 'Toutes';
  double _tempDistance = 20.0;

  // Filtres appliqués (utilisés pour filtrer la liste)
  String _appliedCategory = 'Toutes';
  double _appliedDistance = 20.0;

  // Catégories disponibles
  final List<String> categories = ['Toutes', 'Nature', 'Histoire', 'Culture'];

  // Localisation de l'utilisateur
  Position? _userPosition;

  // Contrôleur pour le champ de saisie manuelle de la localisation
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Obtenir la localisation de l'utilisateur au démarrage
    _getUserLocation();
  }

  // Fonction pour obtenir la localisation de l'utilisateur
  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Le service de localisation n'est pas activé
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez activer la localisation')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // L'utilisateur a refusé la permission
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission de localisation refusée')),
        );
        return;
      }
    }

    // Obtenir la position de l'utilisateur
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _userPosition = position;
      });

      // Calculer les distances des spots par rapport à l'utilisateur
      _calculateDistances();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erreur lors de la récupération de la localisation : $e')),
      );
    }
  }

  // Fonction pour calculer les distances des spots par rapport à l'utilisateur
  void _calculateDistances() {
    if (_userPosition == null) return;

    setState(() {
      for (var spot in allSpots) {
        double distance = Geolocator.distanceBetween(
              _userPosition!.latitude,
              _userPosition!.longitude,
              spot.latitude,
              spot.longitude,
            ) /
            1000; // Convertir en kilomètres
        spot.distance = distance;
      }
    });
  }

  // Fonction pour appliquer les filtres
  void _applyFilters() {
    setState(() {
      // Applique les filtres temporaires
      _appliedCategory = _tempCategory;
      _appliedDistance = _tempDistance;

      // Filtre les spots
      filteredSpots = allSpots.where((spot) {
        // Filtre par mot-clé
        bool matchesQuery = _searchController.text.isEmpty ||
            spot.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            spot.description
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        // Filtre par catégorie
        bool matchesCategory =
            _appliedCategory == 'Toutes' || spot.category == _appliedCategory;

        // Filtre par distance
        bool matchesDistance = spot.distance <= _appliedDistance;

        // Applique tous les filtres
        return matchesQuery && matchesCategory && matchesDistance;
      }).toList();

      // Debug : Affiche les résultats du filtrage
      print('Filtres appliqués :');
      print('Mot-clé : ${_searchController.text}');
      print('Catégorie : $_appliedCategory');
      print('Distance : $_appliedDistance');
      print('Résultats : ${filteredSpots.length} spots trouvés');
    });
  }

  // Fonction pour saisir manuellement la localisation
  Future<void> _setManualLocation() async {
    String location = _locationController.text.trim();
    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer une localisation')),
      );
      return;
    }

    try {
      print('Recherche de la localisation : $location'); // Debug
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        Location firstLocation = locations.first;
        print(
            'Localisation trouvée : ${firstLocation.latitude}, ${firstLocation.longitude}'); // Debug

        setState(() {
          _userPosition = Position(
            latitude: firstLocation.latitude,
            longitude: firstLocation.longitude,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          );
        });

        // Calculer les distances des spots par rapport à la nouvelle localisation
        _calculateDistances();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Localisation mise à jour : $location')),
        );
      } else {
        print('Localisation non trouvée'); // Debug
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Localisation non trouvée')),
        );
      }
    } catch (e) {
      print('Erreur lors de la recherche de la localisation : $e'); // Debug
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erreur lors de la recherche de la localisation : $e')),
      );
    }
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
                _applyFilters(); // Réinitialise la recherche
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Champ de saisie manuelle de la localisation
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Entrez votre ville ou adresse',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _setManualLocation,
                  child: Text('Valider'),
                ),
              ],
            ),
          ),
          // Filtre par catégorie
          Padding(
            padding: EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: _tempCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _tempCategory =
                      newValue!; // Met à jour la catégorie temporaire
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          // Liste des résultats
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filteredSpots[index].description),
                              Text('Ville : ${filteredSpots[index].city}'),
                              Text(
                                  'Distance : ${filteredSpots[index].distance.toStringAsFixed(1)} km'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Filtre par distance (en bas de l'écran)
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                    'Distance maximale : ${_tempDistance.toStringAsFixed(1)} km'),
                Slider(
                  value: _tempDistance,
                  min: 0.0,
                  max: 20.0,
                  divisions: 20,
                  label: _tempDistance.toStringAsFixed(1),
                  onChanged: (double value) {
                    setState(() {
                      _tempDistance =
                          value; // Met à jour la distance temporaire
                    });
                  },
                ),
                // Bouton pour appliquer les filtres
                ElevatedButton(
                  onPressed: _applyFilters,
                  child: Text('Appliquer les filtres'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
