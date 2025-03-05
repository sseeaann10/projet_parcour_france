import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch session data by email from Firestore
  Future<String?> getUidByEmail(String email) async {
    try {
      // Query the 'sessions' collection for the user's session using email
      final querySnapshot = await _db.collection('sessions')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Utilisateur non trouvé');
      }

      // Retrieve uid from the session document
      final sessionData = querySnapshot.docs.first.data();
      return sessionData['uid'];
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la session: $e');
    }
  }

  // Fetch user data from 'users' collection by uid
  Future<User> getUserByUid(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw Exception('Utilisateur non trouvé');
      }

      return User.fromMap({
        'id': doc.id,
        ...doc.data()!,
      });
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur: $e');
    }
  }
}