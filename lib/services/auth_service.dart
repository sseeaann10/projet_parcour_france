import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as app_user;

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtenir l'utilisateur actuel
  firebase_auth.User? get currentUser => _auth.currentUser;

  // Inscription avec email et mot de passe
  Future<app_user.User> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      // Créer le profil utilisateur dans Firestore
      final userData = {
        'id': user.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _db.collection('users').doc(user.uid).set(userData);

      return app_user.User(
        id: user.uid,
        name: name,
        email: email,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Connexion avec email et mot de passe
  Future<app_user.User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      final userDoc = await _db.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        throw Exception('Profil utilisateur non trouvé');
      }

      return app_user.User.fromMap({
        'id': user.uid,
        ...userDoc.data()!,
      });
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Gestion des erreurs Firebase Auth
  Exception _handleAuthException(dynamic e) {
    if (e is firebase_auth.FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return Exception('Cette adresse email est déjà utilisée');
        case 'invalid-email':
          return Exception('Adresse email invalide');
        case 'operation-not-allowed':
          return Exception('Opération non autorisée');
        case 'weak-password':
          return Exception('Le mot de passe est trop faible');
        case 'user-disabled':
          return Exception('Ce compte a été désactivé');
        case 'user-not-found':
          return Exception('Aucun compte trouvé avec cette adresse email');
        case 'wrong-password':
          return Exception('Mot de passe incorrect');
        default:
          return Exception('Une erreur est survenue: ${e.message}');
      }
    }
    return Exception('Une erreur inattendue est survenue');
  }
}
