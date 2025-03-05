import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'search_screen.dart'; // Import other screens as needed
import 'publish_spot_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<QuerySnapshot> _spotsStream;
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContentScreen(),
    SearchScreen(),
    PublishSpotScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch spots published by the current user
      _spotsStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('spots')
          .orderBy('timestamp', descending: true) // Optional: Order by timestamp
          .snapshots();
    }
  }

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mesbonspots'),
      ),
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _handleNavigation,
        selectedItemColor: Colors.blue, // Color for selected tab
        unselectedItemColor: Colors.grey, // Color for unselected tabs
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', // Label for the "Home" tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search', // Label for the "Search" tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.publish),
            label: 'Publish', // Label for the "Publish" tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites', // Label for the "Favorites" tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile', // Label for the "Profile" tab
          ),
        ],
      ),
    );
  }
}

class HomeContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('spots')
          .orderBy('timestamp', descending: true) // Optional: Order by timestamp
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('An error occurred.'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No spots published yet.'));
        }

        final spots = snapshot.data!.docs;

        return ListView.builder(
          itemCount: spots.length,
          itemBuilder: (ctx, index) {
            final spot = spots[index];
            return ListTile(
              title: Text(spot['title']),
              subtitle: Text(spot['description']),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Optionally, navigate to the spot details page
                // Navigator.of(context).pushNamed('/spot-detail', arguments: spot.id);
              },
            );
          },
        );
      },
    );
  }
}
