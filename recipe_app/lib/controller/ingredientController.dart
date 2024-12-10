import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/model/ingredients.dart';

class IngredientController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  String _generateID() {
    var rand = Random();
    return 'ingredient_${DateTime.now().millisecondsSinceEpoch}_${rand.nextInt(1000)}';
  }

  Future<void> addIngredient(Ingredient ingredient) async {
    try {
      String ingredientID = _generateID();

      Ingredient newIngredient = Ingredient(
          id: ingredientID,
          name: ingredient.name,
          description: ingredient.description);

      await _firestore.collection('ingredients').add(newIngredient.toJson());

      print('Ingrediente añadido correctamente con ID: $ingredientID');
    }catch(e)
    {
      print('Error al añadir el ingrediente: $e');
    }
  }

  Future<List<Ingredient>> fetchIngredients() async {
    List<Ingredient> ingredients = [];

    try {
      QuerySnapshot snapshot = await _firestore.collection('ingredients').get();

      for(var doc in snapshot.docs)
        {
          Ingredient ingredient = Ingredient.fromJson(doc.id, doc.data() as Map<String, dynamic>);
          ingredients.add(ingredient);
        }
    }catch(e)
    {
      print('Error al leer los ingredientes: $e');
    }

    return ingredients;
  }
}