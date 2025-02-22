import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Importe l'écran d'accueil

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Démarre avec l'écran d'accueil
    );
  }
}
