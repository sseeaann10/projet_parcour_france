import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import '../models/spot_model.dart';

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
  // Liste d'images simulées pour la galerie
  final List<String> images = [
    'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.tripadvisor.fr%2FAttraction_Review-g1221107-d209763-Reviews-Parc_Asterix-Plailly_Chantilly_Oise_Hauts_de_France.html&psig=AOvVaw0ObsezGtM0IxwSEO5Zc_aB&ust=1740617710366000&source=images&cd=vfe&opi=89978449&ved=0CBYQjRxqFwoTCPCu8bSQ4IsDFQAAAAAdAAAAABAE',
    'https://cdn.sortiraparis.com/images/80/102768/925084-l-ete-gaulois-au-parc-asterix-img-9028.jpg',
    'https://www.cherifaistesvalises.com/wp-content/uploads/2023/05/Shutterstock_2070432857.jpg',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage(images[index]),
                      fit: BoxFit.cover,
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
