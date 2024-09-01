import 'package:flutter/material.dart';
import 'favorites_manager.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'superhero_detail.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<Map<String, dynamic>> _heroDataFuture;
  late List<String> _favorites;

  @override
  void initState() {
    super.initState();
    _heroDataFuture = loadHeroData();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final manager = FavoritesManager();
    final favorites = await manager.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _heroDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || _favorites.isEmpty) {
            return const Center(child: Text('No favorites found.'));
          }

          final heroData = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two columns
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio:
                  0.7, // Adjust to control the aspect ratio of the card
            ),
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              final heroId = _favorites[index];
              final hero = heroData[heroId] ?? {};
              final imageUrl = hero['images']?['lg'] ?? '';
              final name = hero['name'] ?? 'Unknown';
              final fullName = hero['biography']?['fullName'] ?? 'Unknown';
              final firstAppearance =
                  hero['biography']?['firstAppearance'] ?? 'Unknown';

              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuperheroDetailScreen(hero: hero),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              imageUrl,
                              height: 271,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                    child: Text('Image not available'));
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black54,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Full Name: $fullName',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'First Appearance: $firstAppearance',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}

Future<Map<String, dynamic>> loadHeroData() async {
  final jsonString = await rootBundle.loadString('assets/superhero.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);

  // Convert the list to a map where each key is the hero's slug
  final Map<String, dynamic> heroData = {
    for (var hero in jsonList) hero['id'].toString(): hero
  };

  return heroData;
}
