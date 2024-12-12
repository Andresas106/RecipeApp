import 'package:recipe_app/model/ingredients.dart';
import '../model/category.dart';

enum Difficulty {high, medium, low}


class Recipe {
  final String _id;
  final String _title;
  final String _description;
  final List<Ingredient> _ingredients;
  final List<String> _preparation_steps;
  final int _time;
  final Difficulty _difficulty;
  final List<String> _images;
  final Category _category;


  Recipe({
    required String id,
    required String title,
    required String description,
    required List<Ingredient> ingredients,
    required List<String> preparation_steps,
    required int time,
    required Difficulty difficulty,
    required List<String> images,
    required Category category
  })  : _id = id,
        _title= title,
        _description = description,
        _ingredients = ingredients,
        _preparation_steps = preparation_steps,
        _time = time,
        _difficulty = difficulty,
        _images = images,
        _category = category;

  String get id => _id;
  String get title => _title;
  String get description => _description;
  List<Ingredient> get ingredients => _ingredients;
  List<String> get preparation_steps => _preparation_steps;
  int get time => _time;
  Difficulty get difficulty => _difficulty;
  List<String> get images => _images;
  Category get category => _category;

  //Get information from Firebase
  factory Recipe.fromJson(Map<String, dynamic> data)
  {
    return Recipe(
        id: data['id'],
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        ingredients: (data['ingredients'] as List<dynamic>?)
            ?.where((item) => item is Map<String, dynamic>)
            .map((item) => Ingredient.fromJson(item as Map<String, dynamic>))
            .toList() ??
            [],
        preparation_steps: data['preparation_steps'] ?? '',
        time: data['time'] ?? 0,
        difficulty: data['difficulty'] ?? '',
        images: data['images'] ?? '',
        category: data['category'] ?? '');
  }

  //Save information to Firebase
  Map<String, dynamic> toJson()
  {
    return {
      'id' : _id,
      'title' : _title,
      'description' : _description,
      'ingredients' : _ingredients.map((ingredient) => ingredient.toJson()).toList(),
      'preparation_steps' : _preparation_steps,
      'time' : _time,
      'difficulty' : _difficulty,
      'images' : _images,
      'category' : _category
    };
  }
}