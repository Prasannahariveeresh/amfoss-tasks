import 'package:flutter/material.dart';
import 'favorites_manager.dart';

class SuperheroDetailScreen extends StatefulWidget {
  final Map<String, dynamic> hero;

  const SuperheroDetailScreen({Key? key, required this.hero}) : super(key: key);

  @override
  _SuperheroDetailScreenState createState() => _SuperheroDetailScreenState();
}

class _SuperheroDetailScreenState extends State<SuperheroDetailScreen> {
  final FavoritesManager _favoritesManager = FavoritesManager();
  late Future<bool> _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = _favoritesManager.isFavorite(widget.hero['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hero['name']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.network(
                    widget.hero['images']['lg'],
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.hero['name'],
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    widget.hero['biography']['fullName'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Power Stats'),
            _buildPowerStats(context, widget.hero['powerstats']),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Appearance'),
            _buildAppearance(widget.hero['appearance']),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Biography'),
            _buildBiography(widget.hero['biography']),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Work'),
            _buildWork(widget.hero['work']),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Connections'),
            _buildConnections(widget.hero['connections']),
          ],
        ),
      ),
      floatingActionButton: FutureBuilder<bool>(
        future: _isFavorite,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final isFavorite = snapshot.data!;
          return FloatingActionButton(
            onPressed: () async {
              if (isFavorite) {
                await _favoritesManager
                    .removeFavorite(widget.hero['id'].toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          '${widget.hero['name']} removed from favorites')),
                );
              } else {
                await _favoritesManager
                    .addFavorite(widget.hero['id'].toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('${widget.hero['name']} added to favorites')),
                );
              }
              setState(() {
                _isFavorite =
                    _favoritesManager.isFavorite(widget.hero['id'].toString());
              });
            },
            backgroundColor: isFavorite ? Colors.redAccent : Colors.grey,
            child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
    );
  }

  Widget _buildPowerStats(BuildContext context, Map<String, dynamic> stats) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: stats.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key.capitalize(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    entry.value.toString(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAppearance(Map<String, dynamic> appearance) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildDetailRow('Gender', appearance['gender']),
            _buildDetailRow('Race', appearance['race']),
            _buildDetailRow('Height', appearance['height'].join(' / ')),
            _buildDetailRow('Weight', appearance['weight'].join(' / ')),
            _buildDetailRow('Eye Color', appearance['eyeColor']),
            _buildDetailRow('Hair Color', appearance['hairColor']),
          ],
        ),
      ),
    );
  }

  Widget _buildBiography(Map<String, dynamic> biography) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildDetailRow('Full Name', biography['fullName']),
            _buildDetailRow('Alter Egos', biography['alterEgos']),
            _buildDetailRow('Aliases', biography['aliases'].join(', ')),
            _buildDetailRow('Place of Birth', biography['placeOfBirth']),
            _buildDetailRow('First Appearance', biography['firstAppearance']),
            _buildDetailRow('Publisher', biography['publisher']),
            _buildDetailRow('Alignment', biography['alignment']),
          ],
        ),
      ),
    );
  }

  Widget _buildWork(Map<String, dynamic> work) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildDetailRow('Occupation', work['occupation']),
            _buildDetailRow('Base', work['base']),
          ],
        ),
      ),
    );
  }

  Widget _buildConnections(Map<String, dynamic> connections) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildDetailRow(
                'Group Affiliation', connections['groupAffiliation']),
            _buildDetailRow('Relatives', connections['relatives']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value.contains(',')
                  ? value.split(',').join('\n')
                  : value.contains(';')
                      ? value.split(';').join('\n')
                      : value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
