import 'package:flutter/foundation.dart';
import '../models/spot.dart';

class SpotProvider with ChangeNotifier {
  List<Spot> _spots = staticSpots;

  List<Spot> get spots => _spots;

  List<Spot> getSpotsByCategory(String category) {
    return _spots.where((spot) => spot.category == category).toList();
  }

  List<Spot> getSpotsByUser(String userId) {
    return _spots.where((spot) => spot.userId == userId).toList();
  }

  Spot? getSpotById(String id) {
    try {
      return _spots.firstWhere((spot) => spot.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Spot> searchSpots(String query) {
    query = query.toLowerCase();
    return _spots
        .where((spot) =>
            spot.title.toLowerCase().contains(query) ||
            spot.description.toLowerCase().contains(query) ||
            spot.city.toLowerCase().contains(query))
        .toList();
  }

  void addSpot(Spot spot) {
    _spots.add(spot);
    notifyListeners();
  }

  void removeSpot(String id) {
    _spots.removeWhere((spot) => spot.id == id);
    notifyListeners();
  }

  void updateSpot(Spot updatedSpot) {
    final index = _spots.indexWhere((spot) => spot.id == updatedSpot.id);
    if (index != -1) {
      _spots[index] = updatedSpot;
      notifyListeners();
    }
  }
}
