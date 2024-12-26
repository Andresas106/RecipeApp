import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/model/ingredients.dart';
import 'package:recipe_app/utils/stringExtensions.dart';

class IngredientController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Ingredient>> fetchIngredients() async {
    List<Ingredient> ingredients = [];

    try {
      QuerySnapshot snapshot = await _firestore.collection('ingredients').get();

      for(var doc in snapshot.docs)
        {
          Ingredient ingredient = Ingredient.fromJson(doc.data() as Map<String, dynamic>);
          ingredients.add(ingredient);
        }
    }catch(e)
    {
      print('Error al leer los ingredientes: $e');
    }

    return ingredients;
  }

  Future<List<Ingredient>> fetchIngredientsBySearch(String query) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('ingredients')
        .where('name', isGreaterThanOrEqualTo: query.capitalize())
        .where('name', isLessThanOrEqualTo: query.capitalize() + '\uf8ff')
        .get();

    return snapshot.docs.map((doc) {
      return Ingredient.fromJson(doc.data());
    }).toList();
  }

  Future<void> updateIngredientsStock(Ingredient ingredient, int value) async {
    try {
      // Busca el ingrediente en la colección 'ingredients'
      final querySnapshot = await FirebaseFirestore.instance
          .collection('ingredients')
          .where('id', isEqualTo: ingredient.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;

        // Obtiene el stock actual y lo incrementa
        final currentStock = doc.data()['stock'] ?? 0;
        await FirebaseFirestore.instance
            .collection('ingredients')
            .doc(doc.id)
            .update({'stock': currentStock + value});

        // Recupera todas las recetas y actualiza las que contienen el ingrediente
        final recipesSnapshot = await FirebaseFirestore.instance
            .collection('recipes')
            .get(); // Obtener todas las recetas

        for (var recipeDoc in recipesSnapshot.docs) {
          // Extrae el campo de ingredientes de la receta
          final ingredientsList =
          List<Map<String, dynamic>>.from(recipeDoc['ingredients']);

          // Verifica si la receta contiene el ingrediente
          final hasIngredient = ingredientsList.any((ing) => ing['id'] == ingredient.id);

          if (hasIngredient) {
            // Actualiza el stock del ingrediente dentro de la lista
            final updatedIngredientsList = ingredientsList.map((ing) {
              if (ing['id'] == ingredient.id) {
                ing['stock'] = currentStock + value; // Actualiza el stock aquí
              }
              return ing;
            }).toList();

            // Actualiza la receta con la lista modificada
            await FirebaseFirestore.instance
                .collection('recipes')
                .doc(recipeDoc.id)
                .update({'ingredients': updatedIngredientsList});
          }
        }
      }
    } catch (e) {
      print('Error al modificar stock de ingrediente: $e');
    }
  }


}