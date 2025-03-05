import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'screens/home_screen.dart'; // Importe l'écran d'accueil
import 'providers/auth_provider.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/publish_spot_screen.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider()..checkAuthState(),
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Mon Application',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Consumer<AuthProvider>(
                builder: (context, auth, _) =>
                    auth.isLoggedIn ? ProfileScreen() : LoginScreen(),
              ),
          '/profile': (context) => ProfileScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/publish': (context) => PublishSpotScreen()
        },
      ),
    );
  }
}
