import 'package:recipe_app/model/ingredients.dart';
import '../model/category.dart';

enum Dificulty {high, medium, low}


class Recipe {
  final String _id;
  final String _title;
  final String _description;
  final List<Ingredient> _ingredients;
  final List<String> _preparation_steps;
  final int time;
  final Dificulty _dificulty;
  final List<String> _images;
  final Category category;


  Recipe({
    required String id,
    required String title,
    required String description,
    required List<Ingredient> ingredients,
    required
  })  : _title= title,
        _description = description,
        _id = id,
        _ingredients = ingredients,
        ;

  String get name => _title;
  String get description => _description;
  String get id => _id;


  //Get information from Firebase
  /*factory Category.fromJson(String id, Map<String, dynamic> data)
  {
    return Category(
        id: id,
        name: data['name'] ?? '',
        description: data['description'] ?? '');
  }

  //Save information to Firebase
  Map<String, dynamic> toJson()
  {
    return {
      'id' : _id,
      'name' : _name,
      'description' : _description,
    };
  }*/
}