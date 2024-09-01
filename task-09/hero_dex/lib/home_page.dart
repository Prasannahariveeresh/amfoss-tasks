import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'superhero_detail.dart';
import 'superhero_list.dart';
import 'favorites_manager.dart';
import 'favorites.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _superheroes = [];
  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadSuperheroes();
  }

  Future<void> _loadSuperheroes() async {
    final String response =
        await rootBundle.loadString('assets/superhero.json');
    final List<dynamic> data = jsonDecode(response);

    setState(() {
      _superheroes = data;
    });

    // Load favorites after superheroes are loaded
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final manager = FavoritesManager();
    final favorites = await manager.getFavorites();

    setState(() {
      _favorites = _superheroes
          .where((hero) => favorites.contains(hero['id'].toString()))
          .map((hero) => hero as Map<String, dynamic>)
          .toList();
    });
  }

  List<dynamic> _getRandomSuperheroes(int count) {
    final random = Random();
    if (_superheroes.isEmpty) return [];
    return List<dynamic>.generate(
        count, (index) => _superheroes[random.nextInt(_superheroes.length)]);
  }

  @override
  Widget build(BuildContext context) {
    final randomHeroes = _getRandomSuperheroes(10);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HeroDex'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _carouselSlider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Superheroes you might like',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            _buildHorizontalScroll(randomHeroes, false),
            if (_favorites.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Favorites',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              _buildHorizontalScroll(_favorites, true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalScroll(List<dynamic> heroes, bool isFavorite) {
    return SizedBox(
      height: 225,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: heroes.length + 1,
        itemBuilder: (context, index) {
          if (index == heroes.length) {
            return _buildSeeMoreCard(isFavorite ? 'Favorites' : 'Superheroes');
          }

          final hero = heroes[index];
          return _buildHeroCard(hero, isFavorite);
        },
      ),
    );
  }

  Widget _buildHeroCard(Map<String, dynamic> hero, bool isFavorite) {
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
        child: Column(
          children: [
            Image.network(
              hero['images']['lg'] ?? '',
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Image not available'));
              },
            ),
            const SizedBox(height: 8),
            Text(
              hero['name'] ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${hero['appearance']?['gender'] ?? 'Unknown'}, ${hero['appearance']?['race'] ?? 'Unknown'}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _carouselSlider() {
    List<dynamic> randomHeroes = _getRandomSuperheroes(5);

    return Center(
      child: CarouselSlider.builder(
        itemCount: randomHeroes.length,
        options: CarouselOptions(
          height: 400,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          aspectRatio: 2.0,
          enableInfiniteScroll: true,
        ),
        itemBuilder: (context, index, realIndex) {
          final hero = randomHeroes[index];

          return HeroCard(
            name: hero['name'] ?? 'Unknown',
            imageUrl: hero['images']?['lg'] ?? '',
            heroObj: hero,
          );
        },
      ),
    );
  }

  Widget _buildSeeMoreCard(String screen) {
    return GestureDetector(
      onTap: () {
        if (screen == 'Superheroes') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SuperheroListScreen()),
          );
        } else if (screen == 'Favorites') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesScreen()),
          );
        }
      },
      child: const Card(
        child: SizedBox(
          width: 150,
          child: Center(
            child: Text(
              'See More',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final Map<String, dynamic> heroObj;

  const HeroCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.heroObj,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 392,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Image not available'));
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
                        'Full Name: $name',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
