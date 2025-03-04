import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/review_model.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../screens/signup_screen.dart';
import '../screens/login_screen.dart';
import '../models/spot.dart';

class SpotDetailsScreen extends StatefulWidget {
  final Spot spot;
  final Function(Spot) onAddToFavorites;

  SpotDetailsScreen({
    required this.spot,
    required this.onAddToFavorites,
  });

  @override
  _SpotDetailsScreenState createState() => _SpotDetailsScreenState();
}

class _SpotDetailsScreenState extends State<SpotDetailsScreen> {
  final List<Review> reviews = [];
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  double _userRating = 0.0;
  Position? _userPosition;
  bool _isUsingCustomAddress = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _userPosition = position;
      });
    } catch (e) {
      print('Erreur de géolocalisation: $e');
    }
  }

  Future<void> _searchAddress() async {
    try {
      List<Location> locations =
          await locationFromAddress(_addressController.text);
      if (locations.isNotEmpty) {
        setState(() {
          _userPosition = Position(
            latitude: locations.first.latitude,
            longitude: locations.first.longitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
          _isUsingCustomAddress = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adresse non trouvée')),
      );
    }
  }

  Future<void> _openInMaps() async {
    if (_userPosition == null && !_isUsingCustomAddress) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Localisation non disponible')),
      );
      return;
    }

    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=${_userPosition!.latitude},${_userPosition!.longitude}&destination=${widget.spot.latitude},${widget.spot.longitude}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d\'ouvrir Google Maps')),
      );
    }
  }

  void _submitReview() {
    if (_commentController.text.isNotEmpty && _userRating > 0) {
      final review = Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.spot.userId,
        spotId: widget.spot.id,
        rating: _userRating,
        comment: _commentController.text,
        createdAt: DateTime.now(),
      );
      setState(() {
        reviews.add(review);
        _commentController.clear();
        _userRating = 0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  }

  Widget _buildReviewSection(BuildContext context, bool isLoggedIn) {
    if (!isLoggedIn) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Connectez-vous pour laisser un avis',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
                  child: Text('Se connecter'),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  ),
                  child: Text('S\'inscrire'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Commentaire',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 16.0),
          Text('Notez ce spot :'),
          Row(
            children: List.generate(
              5,
              (index) => IconButton(
                icon: Icon(
                  Icons.star,
                  color: _userRating >= index + 1 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _userRating = index + 1;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _submitReview,
            child: Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.spot.title),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => widget.onAddToFavorites(widget.spot),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    widget.spot.images[index],
                    fit: BoxFit.cover,
                  );
                },
                itemCount: widget.spot.images.length,
                pagination: SwiperPagination(),
                control: SwiperControl(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.spot.title,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(widget.spot.description),
                  SizedBox(height: 16.0),
                  Text('Catégorie : ${widget.spot.category}'),
                  SizedBox(height: 8.0),
                  Text('Adresse : ${widget.spot.address}'),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            hintText: 'Entrez votre adresse de départ',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: _searchAddress,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.my_location),
                        onPressed: _getUserLocation,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: _openInMaps,
                    icon: Icon(Icons.directions),
                    label: Text('Calculer l\'itinéraire'),
                  ),
                ],
              ),
            ),
            Container(
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(widget.spot.latitude, widget.spot.longitude),
                  zoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.projet_parcour_france.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point:
                            LatLng(widget.spot.latitude, widget.spot.longitude),
                        child: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildReviewSection(context, authProvider.isLoggedIn),
          ],
        ),
      ),
    );
  }
}
