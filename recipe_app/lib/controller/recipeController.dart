import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/model/recipe.dart';

class RecipeController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  String generateID() {
    var rand = Random();
    return 'recipe_${DateTime.now().millisecondsSinceEpoch}_${rand.nextInt(1000)}';
  }

  Future<List<Recipe>> fetchRecipes() async {
    List<Recipe> recipes = [];

    try {
      QuerySnapshot snapshot = await _firestore.collection('recipes').get();

      for(var doc in snapshot.docs)
      {
        Recipe recipe = Recipe.fromJson(doc.data() as Map<String, dynamic>);
        recipes.add(recipe);
      }
    }catch(e)
    {
      print('Error al leer las recetas: $e');
    }

    return recipes;
  }

  Future<bool> addRecipe(Recipe recipe) async {
    try {
      String id = recipe.id.isEmpty ? generateID() : recipe.id;
      await _firestore.collection('recipes').doc(id).set(recipe.toJson());
      return true;
    }catch(e)
    {
      return false;
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _firestore.collection('recipes').doc(id).delete();
    }catch(e)
    {
      print('Error al eliminar receta: $e');
    }
  }

  Future<bool> updateRecipe(Recipe recipe) async {
    try {
      await _firestore.collection('recipes').doc(recipe.id).update(recipe.toJson());
      return true;
    }catch(e) {
      return false;
    }
  }
}