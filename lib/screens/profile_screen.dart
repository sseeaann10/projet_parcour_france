import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  final _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed('/edit-profile');
            },
          ),
        ],
      ),
      body: FutureBuilder<User>(
        future: _databaseService.getUserProfile(authProvider.userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Une erreur est survenue: ${snapshot.error}'));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
                SizedBox(height: 24),
                Text(
                  user.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildInfoCard(
                  icon: Icons.email,
                  title: 'Email',
                  value: user.email,
                ),
                _buildInfoCard(
                  icon: Icons.phone,
                  title: 'Téléphone',
                  value: user.phone ?? 'Non renseigné',
                ),
                _buildInfoCard(
                  icon: Icons.location_on,
                  title: 'Adresse',
                  value: user.address ?? 'Non renseignée',
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    authProvider.logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  icon: Icon(Icons.logout),
                  label: Text('Se déconnecter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
