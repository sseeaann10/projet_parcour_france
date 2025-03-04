import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../models/review_model.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../screens/signup_screen.dart';
import '../screens/login_screen.dart';
import '../models/spot.dart';

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
  final List<Review> reviews = [];
  final TextEditingController _commentController = TextEditingController();
  double _userRating = 0.0;

  void _submitReview() {
    if (_commentController.text.isNotEmpty && _userRating > 0) {
      final review = Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.spot.userId,
        spotId: widget.spot.id,
        rating: _userRating,
        comment: _commentController.text,
        createdAt: DateTime.now(),
      );
      setState(() {
        reviews.add(review);
        _commentController.clear();
        _userRating = 0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  }

  Widget _buildReviewSection(BuildContext context, bool isLoggedIn) {
    if (!isLoggedIn) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Connectez-vous pour laisser un avis',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
                  child: Text('Se connecter'),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  ),
                  child: Text('S\'inscrire'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                icon: Icon(
                  Icons.star,
                  color: _userRating >= index + 1 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _userRating = index + 1;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _submitReview,
            child: Text('Envoyer'),
          ),
        ],
      ),
    );
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    widget.spot.images[index],
                    fit: BoxFit.cover,
                  );
                },
                itemCount: widget.spot.images.length,
                pagination: SwiperPagination(),
                control: SwiperControl(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.spot.title,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(widget.spot.description),
                  SizedBox(height: 16.0),
                  Text('Catégorie : ${widget.spot.category}'),
                  SizedBox(height: 8.0),
                  Text('Adresse : ${widget.spot.address}'),
                ],
              ),
            ),
            _buildReviewSection(context, authProvider.isLoggedIn),
          ],
        ),
      ),
    );
  }
}
