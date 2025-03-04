import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/auth_provider.dart';
import '../providers/spot_provider.dart';
import '../models/spot.dart';

class PublishSpotScreen extends StatefulWidget {
  @override
  _PublishSpotScreenState createState() => _PublishSpotScreenState();
}

class _PublishSpotScreenState extends State<PublishSpotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _addressController = TextEditingController();
  List<String> _selectedImages = [];

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((image) => image.path).toList());
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitSpot(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez ajouter au moins une image')),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final spotProvider = Provider.of<SpotProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);

      try {
        final spot = Spot(
          id: '',
          userId: authProvider.currentUser!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          category: _categoryController.text,
          address: _addressController.text,
          images: _selectedImages,
          rating: 0.0,
          city: '', // À remplir plus tard avec l'API de géocodage
          latitude: 0.0, // À remplir plus tard avec l'API de géocodage
          longitude: 0.0, // À remplir plus tard avec l'API de géocodage
        );

        spotProvider.addSpot(spot);
        messenger.showSnackBar(
          const SnackBar(content: Text('Spot publié avec succès !')),
        );
        navigator.pop();
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text('Erreur lors de la publication : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publier un spot'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Catégorie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une catégorie';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Adresse complète'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Text(
                'Galerie d\'images',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              if (_selectedImages.isNotEmpty)
                Container(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Image.file(
                              File(_selectedImages[index]),
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () => _removeImage(index),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImages,
                icon: Icon(Icons.add_photo_alternate),
                label: Text('Ajouter des photos'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _submitSpot(context),
                child: Text('Publier'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
