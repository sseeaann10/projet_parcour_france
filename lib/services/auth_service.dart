import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as app_user;

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get the current user
  firebase_auth.User? getCurrentUser() {
  return _auth.currentUser;
}

  // Sign up method
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

      // Create user profile in Firestore
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

  // Sign in method
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
        throw Exception('User profile not found');
      }

      return app_user.User.fromMap({
        'id': user.uid,
        ...userDoc.data()!,
      });
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Handle Firebase Auth exceptions
  Exception _handleAuthException(dynamic e) {
    if (e is firebase_auth.FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return Exception('This email is already in use');
        case 'invalid-email':
          return Exception('Invalid email address');
        case 'operation-not-allowed':
          return Exception('Operation not allowed');
        case 'weak-password':
          return Exception('Password is too weak');
        case 'user-disabled':
          return Exception('This account has been disabled');
        case 'user-not-found':
          return Exception('No account found with this email');
        case 'wrong-password':
          return Exception('Incorrect password');
        default:
          return Exception('An error occurred: ${e.message}');
      }
    }
    return Exception('An unexpected error occurred');
  }
}
