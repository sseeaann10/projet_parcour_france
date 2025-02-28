import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../models/review_model.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../screens/signup_screen.dart';
import '../db/database.dart';

class SpotDetailsScreen extends StatefulWidget {
  final Spot spot;
  final Function(Spot) onAddToFavorites;

  SpotDetailsScreen({
    required this.spot,
    required this.onAddToFavorites,
  });

  @override
  _SpotDetailsScreenState createState() => _SpotDetailsScreenState();
}

class _SpotDetailsScreenState extends State<SpotDetailsScreen> {
  final List<String> images = [];
  final List<Review> reviews = [];

  final TextEditingController _commentController = TextEditingController();

  int _currentIndex = 0;

  double _userRating = 0.0;

  void _submitReview() {
    if (_commentController.text.isNotEmpty && _userRating > 0) {
      final review = Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.spot.userId,
        rating: _userRating,
        comment: _commentController.text,
        date: DateTime.now(),
      );
      setState(() {
        reviews.add(review);
        _commentController.clear();
        _userRating = 0;
      });

      _commentController.clear();
      _userRating = 0;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.spot.title),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () => widget.onAddToFavorites(widget.spot),
          ),
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              if (authProvider.isLoggedIn) {
                authProvider.logout();
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              itemCount: images.length,
              pagination: SwiperPagination(),
              control: SwiperControl(),
              autoplay: true,
              onIndexChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.spot.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Commentaire',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16.0),
                Text('Notez ce spot :'),
                Row(
                  children: List.generate(
                      5,
                      (index) => IconButton(
                            icon: Icon(Icons.star,
                                color: _userRating >= index + 1
                                    ? Colors.yellow
                                    : Colors.grey),
                            onPressed: () {
                              setState(() {
                                _userRating = index + 1;
                              });
                            },
                          )),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitReview,
                  child: Text('Envoyer'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              int index = entry.key;
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.spot.title,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Image.network(widget.spot.image),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(widget.spot.description),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Catégorie : ${widget.spot.category}'),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Distance : ${widget.spot.distance} km'),
          ),
        ],
      ),
    );
  }
}
