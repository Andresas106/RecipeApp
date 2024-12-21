import 'package:recipe_app/model/ingredients.dart';
import '../model/category.dart';

enum Difficulty {high, medium, low}


class Recipe {
  final String _id;
  final String _title;
  final String _description;
  final List<Ingredient> _ingredients;
  final Map<String, int> _ingredientQuantities;
  final List<String> _preparation_steps;
  final int _time;
  final Difficulty _difficulty;
  final String _image;
  final Category _category;


  Recipe({
    required String id,
    required String title,
    required String description,
    required List<Ingredient> ingredients,
    required Map<String, int> ingredientQuantities,
    required List<String> preparation_steps,
    required int time,
    required Difficulty difficulty,
    required String image,
    required Category category
  })  : _id = id,
        _title= title,
        _description = description,
        _ingredients = ingredients,
        _ingredientQuantities = ingredientQuantities,
        _preparation_steps = preparation_steps,
        _time = time,
        _difficulty = difficulty,
        _image = image,
        _category = category;

  String get id => _id;
  String get title => _title;
  String get description => _description;
  List<Ingredient> get ingredients => _ingredients;
  Map<String, int> get ingredientQuantities => _ingredientQuantities;
  List<String> get preparation_steps => _preparation_steps;
  int get time => _time;
  Difficulty get difficulty => _difficulty;
  String get image => _image;
  Category get category => _category;

  //Get information from Firebase
  factory Recipe.fromJson(Map<String, dynamic> data)
  {
    var ingredientQuantities = (data['ingredient_quantities'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, value as int),
    ) ?? {};

    return Recipe(
        id: data['id'],
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        ingredients: (data['ingredients'] as List<dynamic>?)
            ?.where((item) => item is Map<String, dynamic>)
            .map((item) => Ingredient.fromJson(item as Map<String, dynamic>))
            .toList() ??
            [],
        ingredientQuantities: ingredientQuantities,
        preparation_steps: data['preparation_steps'] ?? '',
        time: data['time'] ?? 0,
        difficulty: data['difficulty'] ?? '',
        image: data['image'] ?? '',
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
      'ingredient_quantities': _ingredientQuantities,
      'preparation_steps' : _preparation_steps,
      'time' : _time,
      'difficulty' : _difficulty,
      'image' : _image,
      'category' : _category
    };
  }
}


extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.high:
        return 'High';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.low:
        return 'Low';
      default:
        return '';
    }
  }
}