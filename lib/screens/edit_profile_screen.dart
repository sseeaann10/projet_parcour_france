import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  File? _profileImage;

  final ImagePicker _Picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Avatar Aang ';
    _emailController.text = 'aang@avatar.com';
    _bioController.text = 'Passionné de voyages et de découvertes.';
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _Picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _takePhotoWithCamera() async {
    final XFile? image = await _Picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le profil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Afficher un menu pour choisir entre la galerie et l'appareil photo
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Choisir depuis la galerie'),
                          onTap: () {
                            _pickImageFromGallery();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text('Prendre une photo'),
                          onTap: () {
                            _takePhotoWithCamera();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(
                        _profileImage!) // Afficher la photo sélectionnée
                    : NetworkImage(
                            'https://sm.ign.com/ign_fr/cover/a/avatar-gen/avatar-generations_bssq.jpg')
                        as ImageProvider, // Photo par défaut
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'A propos',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Logique pour enregistrer les modifications
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
