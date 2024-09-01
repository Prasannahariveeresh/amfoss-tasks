import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const String _favoritesKey = 'favorites';

  Future<void> addFavorite(String heroId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favorites = prefs.getStringList(_favoritesKey);
    final List<String> updatedFavorites =
        favorites != null ? List<String>.from(favorites) : [];

    if (!updatedFavorites.contains(heroId)) {
      updatedFavorites.add(heroId);
      await prefs.setStringList(_favoritesKey, updatedFavorites);
    }
  }

  Future<void> removeFavorite(String heroId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favorites = prefs.getStringList(_favoritesKey);
    if (favorites != null) {
      final List<String> updatedFavorites = List<String>.from(favorites)
        ..remove(heroId);
      await prefs.setStringList(_favoritesKey, updatedFavorites);
    }
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? <String>[];
  }

  Future<bool> isFavorite(String heroId) async {
    final favorites = await getFavorites();
    return favorites.contains(heroId);
  }
}
