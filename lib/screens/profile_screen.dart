import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import './login_screen.dart';
import './signup_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  String? _selectedImagePath;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      _usernameController.text = user.name;
      _bioController.text = '';
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implémenter la sauvegarde du profil avec l'API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profil')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Connectez-vous pour accéder à votre profil',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text('Se connecter'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                ),
                child: Text('Créer un compte'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImagePath != null
                        ? FileImage(File(_selectedImagePath!))
                        : (user.photoUrl != null
                            ? NetworkImage(user.photoUrl!) as ImageProvider
                            : AssetImage('assets/images/default_avatar.png')),
                  ),
                  if (_isEditing)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 20,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 24),
              if (!_isEditing) ...[
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 8),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (_bioController.text.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Text(
                    _bioController.text,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Modifier le profil'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ] else ...[
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nom d\'utilisateur',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom d\'utilisateur';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          _usernameController.text = user.name;
                          _bioController.text = '';
                          _selectedImagePath = null;
                        });
                      },
                      child: Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveProfile();
                          setState(() {
                            _isEditing = false;
                          });
                        }
                      },
                      child: Text('Enregistrer'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
