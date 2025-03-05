import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'publish_spot_screen.dart'; // Import the publish spot screen

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  late User _user;
  late Future<DocumentSnapshot> _userData; // No need for 'late' initialization here

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!; // Ensure user is logged in
    _userData = FirebaseFirestore.instance.collection('sessions').doc(_user.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user data found.'));
          }

          var userDoc = snapshot.data!;
          String email = userDoc['email'] ?? 'No email available';
          Timestamp loginTimestamp = userDoc['loginTimestamp'] ?? Timestamp.now();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: $email', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 10),
                Text('Last Login: ${loginTimestamp.toDate()}',
                    style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the PublishSpotScreen when button is pressed
                    Navigator.of(context).pushNamed('/publish');
                  },
                  child: Text('Publier un Spot'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
