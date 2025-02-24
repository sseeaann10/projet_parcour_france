import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section informations utilisateur
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://sm.ign.com/ign_fr/cover/a/avatar-gen/avatar-generations_bssq.jpg'),
                  radius: 40,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avatar Aang',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text('aang@avatar.com'),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ),
                        );
                      },
                      child: Text('Modifier'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Section autres informations (optionnelle)
            Text(
              'À propos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Passionné de voyages et de découvertes.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
