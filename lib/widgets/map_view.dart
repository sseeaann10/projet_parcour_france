import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/spot.dart';

class MapView extends StatefulWidget {
  final List<Spot> spots;
  final Function(Spot) onSpotTap;

  const MapView({
    Key? key,
    required this.spots,
    required this.onSpotTap,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? _userLocation;
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Erreur de géolocalisation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'Entrez votre adresse',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        try {
                          final List<Location> locations =
                              await locationFromAddress(
                                  _addressController.text);
                          if (locations.isNotEmpty) {
                            setState(() {
                              _userLocation = LatLng(
                                locations.first.latitude,
                                locations.first.longitude,
                              );
                            });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Adresse non trouvée')),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.my_location),
                onPressed: _getCurrentLocation,
              ),
            ],
          ),
        ),
        Expanded(
          child: FlutterMap(
            options: MapOptions(
              center: _userLocation ?? LatLng(46.603354, 1.888334),
              zoom: 6.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.projet_parcour_france.app',
              ),
              MarkerLayer(
                markers: [
                  if (_userLocation != null)
                    Marker(
                      point: _userLocation!,
                      child: Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ...widget.spots
                      .map((spot) => Marker(
                            point: LatLng(spot.latitude, spot.longitude),
                            child: GestureDetector(
                              onTap: () => widget.onSpotTap(spot),
                              child: Icon(
                                Icons.location_on,
                                color: Theme.of(context).primaryColor,
                                size: 40,
                              ),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
