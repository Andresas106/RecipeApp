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
}