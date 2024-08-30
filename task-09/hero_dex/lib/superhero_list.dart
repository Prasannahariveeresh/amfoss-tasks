import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'superhero_detail.dart';

class SuperheroListScreen extends StatefulWidget {
  const SuperheroListScreen({super.key});

  @override
  _SuperheroListScreenState createState() => _SuperheroListScreenState();
}

class _SuperheroListScreenState extends State<SuperheroListScreen> {
  List<dynamic>? _superheroes;
  List<dynamic>? _filteredSuperheroes;
  bool _isLoading = true;
  bool _hasError = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSuperheroesData();
    _searchController.addListener(_filterSuperheroes);
  }

  void _loadSuperheroesData() {
    rootBundle.loadString('assets/superhero.json').then((response) {
      try {
        var data = jsonDecode(response);
        setState(() {
          _superheroes = data;
          _filteredSuperheroes = data;
          _isLoading = false;
          _hasError = false;
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    });
  }

  void _filterSuperheroes() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredSuperheroes = _superheroes;
      });
    } else {
      setState(() {
        _filteredSuperheroes = _superheroes!.where((hero) {
          final name = hero['name'].toString().toLowerCase();
          final fullName =
              hero['biography']['fullName'].toString().toLowerCase();
          return name.contains(query) || fullName.contains(query);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Superheroes')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Superheroes')),
        body: const Center(child: Text('Error loading superheroes')),
      );
    }

    if (_filteredSuperheroes == null || _filteredSuperheroes!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Superheroes')),
        body: const Center(child: Text('No superheroes found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Superheroes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search superheroes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredSuperheroes!.length,
        itemBuilder: (context, index) {
          final hero = _filteredSuperheroes![index];
          return Card(
            child: ListTile(
              leading: Image.network(hero['images']['sm']),
              title: Text(hero['name']),
              subtitle: Text(hero['biography']['fullName']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuperheroDetailScreen(hero: hero),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
