import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'screens/home_screen.dart'; // Importe l'écran d'accueil
import 'providers/auth_provider.dart';
import 'db/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await database.insertInitialSpots();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        Provider.value(value: database),
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
      title: 'Bottom Navigation Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Démarre avec l'écran d'accueil
    );
  }
}

class DatabaseApp extends StatefulWidget {
  @override
  _DatabaseAppState createState() => _DatabaseAppState();
}

class _DatabaseAppState extends State<DatabaseApp> {
  late AppDatabase database;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    database = AppDatabase();
    _refreshUsers();
  }

  Future<void> _refreshUsers() async {
    final users = await database.allUsers;
    setState(() {
      _users = users;
    });
  }

  Future<void> _addUser() async {
    await database.insertUser(
      UsersCompanion(
          name: Value('Nouveau utilisateur'),
          email: Value('email@example.com'),
          password: Value('password123')),
    );
    _refreshUsers();
  }

  void _deleteUser(int id) async {
    await database.deleteUser(id);
    _refreshUsers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Drift SQLite avec Flutter")),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: _addUser,
              child: Text("Ajouter un utilisateur"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteUser(user.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
