import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/model/ingredients.dart';
import 'package:recipe_app/utils/stringExtensions.dart';

class IngredientController {

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
      final querySnapshot = await FirebaseFirestore.instance
          .collection('ingredients')
          .where('id', isEqualTo: ingredient.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;

        final currentStock = doc.data()['stock'] ?? 0;
        await FirebaseFirestore.instance
            .collection('ingredients')
            .doc(doc.id)
            .update({'stock': currentStock + value});

        final recipesSnapshot = await FirebaseFirestore.instance
            .collection('recipes')
            .get();

        for (var recipeDoc in recipesSnapshot.docs) {
          final ingredientsList = List<Map<String, dynamic>>.from(recipeDoc['ingredients']);

          final hasIngredient = ingredientsList.any((ing) => ing['id'] == ingredient.id);

          if (hasIngredient) {
            final updatedIngredientsList = ingredientsList.map((ing) {
              if (ing['id'] == ingredient.id) {
                ing['stock'] = currentStock + value;
              }
              return ing;
            }).toList();

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