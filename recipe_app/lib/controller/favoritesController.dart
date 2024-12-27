import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController {
  static const _keyFavorites = 'favorites';

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavorites) ?? [];
  }

  static Future<void> addFavorite(String recipeID) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if(!favorites.contains(recipeID)) {
      favorites.add(recipeID);
      await prefs.setStringList(_keyFavorites, favorites);
    }
  }

  static Future<void> deleteRecipe(String recipeID) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.remove(recipeID);
    prefs.setStringList(_keyFavorites, favorites);
  }

  static Future<bool> isfavorite(String recipeID) async{
    final favorites = await getFavorites();
    return favorites.contains(recipeID);
  }
}