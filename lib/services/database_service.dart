import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User> getUserProfile(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception('Utilisateur non trouvé');
      }
      return User.fromMap({
        'id': doc.id,
        ...doc.data()!,
      });
    } catch (e) {
      throw Exception('Erreur lors de la récupération du profil: $e');
    }
  }

  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(userId).update(data);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du profil: $e');
    }
  }
}
