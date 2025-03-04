import '../models/user.dart';

class DatabaseService {
  Future<User> getUserProfile(String userId) async {
    try {
      final user = staticUsers.firstWhere(
        (user) => user.id == userId,
        orElse: () => throw Exception('Utilisateur non trouvé'),
      );
      return user;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du profil: $e');
    }
  }

  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      final index = staticUsers.indexWhere((user) => user.id == userId);
      if (index == -1) {
        throw Exception('Utilisateur non trouvé');
      }

      final updatedUser = User.fromMap({
        ...staticUsers[index].toMap(),
        ...data,
      });

      staticUsers[index] = updatedUser;
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du profil: $e');
    }
  }
}
