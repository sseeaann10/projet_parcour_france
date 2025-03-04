import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart'; // Importe l'écran d'accueil
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/spot_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => SpotProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes Bons Spots',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/login': (context) => LoginScreen(),
      },
      initialRoute: '/',
    );
  }
}
