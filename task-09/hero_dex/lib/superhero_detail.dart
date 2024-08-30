import 'package:flutter/material.dart';

class SuperheroDetailScreen extends StatelessWidget {
  final Map<String, dynamic> hero;

  SuperheroDetailScreen({required this.hero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hero['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(hero['images']['lg']),
            const SizedBox(height: 10),
            Text(
              '${hero['name']}',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium, // Updated for recent Flutter versions
            ),
            Text('Full Name: ${hero['biography']['fullName']}'),
            Text('Publisher: ${hero['biography']['publisher']}'),
            Text('Occupation: ${hero['work']['occupation']}'),
            Text(
                'Group Affiliation: ${hero['connections']['groupAffiliation']}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
