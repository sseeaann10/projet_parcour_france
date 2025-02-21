import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

/* @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Mes Bons Spots"),
        ),
        body: Center(
          child: Text("Hello, World!!!"),
        ),
      ),
    );
  }
} */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mes Bons Spots",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Screen1(),
    Screen2(),
    Screen3(),
    Screen4(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Recherche",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoris",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Ecran Accueil",
      style: TextStyle(fontSize: 24),
    ));
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Ecran Recherche",
      style: TextStyle(fontSize: 24),
    ));
  }
}

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Favoris",
      style: TextStyle(fontSize: 24),
    ));
  }
}

class Screen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Ecran Profil",
      style: TextStyle(fontSize: 24),
    ));
  }
}
