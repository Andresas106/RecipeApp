import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/model/recipe.dart';

class RecipeController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> addRecipe() async {
    try {
      // Datos de prueba para la receta
      Map<String, dynamic> recipeData = {
        'id': '1',
        'title': 'Pizza Margherita',
        'description': 'Pizza italiana clásica con tomate, mozzarella y albahaca.',
        'ingredients': [
          {
            'id': 'ing1',
            'name': 'Tomate',
            'description': 'Tomates frescos triturados.',
            'stock': 200,
            'unit': 'g',
          },
          {
            'id': 'ing2',
            'name': 'Mozzarella',
            'description': 'Queso mozzarella fresco.',
            'stock': 150,
            'unit': 'g',
          },
          {
            'id': 'ing3',
            'name': 'Albahaca',
            'description': 'Hojas de albahaca fresca.',
            'stock': 10,
            'unit': 'hojas',
          }
        ],
        'preparation_steps': [
          'Precalentar el horno a 220°C.',
          'Extender la masa de pizza.',
          'Añadir la salsa de tomate, mozzarella y albahaca.',
          'Hornear durante 10-15 minutos.'
        ],
        'time': 20,
        'difficulty': 'medium',
        'images': ['https://positano.lv/wp-content/uploads/2021/12/Margherita-1-300x300.png'],
        'category': {
          'id': 'cat1',
          'name': 'Pizza',
          'description': 'Platos italianos.',
        },
      };

      // Insertar receta en Firestore
      await _firestore.collection('recipes').doc('1').set(recipeData);

      print('Receta añadida exitosamente.');
    } catch (e) {
      print('Error al añadir receta: $e');
    }
  }
}