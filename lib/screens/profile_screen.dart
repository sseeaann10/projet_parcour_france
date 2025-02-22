import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, String> user = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'image': 'https://via.placeholder.com/150',
  };

  final List<Map<String, String>> favorites = [
    {
      'title': 'Spot 1',
      'description': 'Un endroit magnifique pour se détendre.',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Spot 2',
      'description': 'Parfait pour les amateurs de nature.',
      'image': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user['image']!),
                  radius: 40,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name']!,
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(user['email']!),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(favorites[index]['image']!),
                    title: Text(favorites[index]['title']!),
                    subtitle: Text(favorites[index]['description']!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
