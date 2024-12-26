import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/controller/ingredientController.dart';
import 'package:recipe_app/model/ingredients.dart';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/widgets/recipeShoppingItem.dart';

import '../controller/recipeController.dart';
import '../navigation/AppRouterDelegate.dart';
import '../utils/authService.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final recipeController = RecipeController();
  final ingredientController = IngredientController();
  List<Recipe> _recipesList = [];
  List<Recipe> _selectedRecipes = [];

  @override
  void initState() {
    super.initState();
    _getRecipes();
  }

  Future<void> _getRecipes() async {
    final recipes = await recipeController.fetchRecipes();
    setState(() {
      _recipesList = recipes;
    });
  }

  void _handleRecipeSelection(Recipe recipe, bool? isSelected) {
    setState(() {
      if (isSelected == true) {
        _selectedRecipes.add(recipe);
      } else {
        _selectedRecipes.remove(recipe);
      }
    });
  }

  Future<void> _updateIngredientsForSelectedRecipes(
      List<Recipe> selectedRecipes, int value) async {
    try {
      final Set<int> uniqueIngredientsID = {};
      final Map<int, Ingredient> uniqueIngredientsMap = {};

      for (Recipe recipe in selectedRecipes) {
        for (Ingredient ingredient in recipe.ingredients) {
          if (!uniqueIngredientsID.contains(ingredient.id)) {
            uniqueIngredientsID.add(ingredient.id);
            uniqueIngredientsMap[ingredient.id] = ingredient;
          }
        }
      }

      for (int ingredientID in uniqueIngredientsID) {
        final ingredient = uniqueIngredientsMap[ingredientID];

        if (ingredient != null) {
          await ingredientController.updateIngredientsStock(ingredient, value);
        }

        _getRecipes();
      }
    } catch (e) {
      print('Error al actualizar los stocks de ingredientes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ingredients Shopping',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              _authService.logout();
              final routerDelegate = Router.of(context).routerDelegate as AppRouterDelegate;
              routerDelegate.setNewRoutePath(RouteSettings(name: '/login'));
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (ctx, index) => const Divider(
                  height: 25,
                  color: Colors.teal,
                ),
                itemCount: _recipesList.length,
                itemBuilder: (ctx, i) {
                  final recipe = _recipesList[i];
                  final isSelected = _selectedRecipes.contains(recipe);
                  return RecipeShoppingItem(
                    recipe: recipe,
                    isSelected: isSelected,
                    onSelectedChanged: (isSelected) =>
                        _handleRecipeSelection(recipe, isSelected),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedRecipes.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext builder) {
                        return AlertDialog(
                          title: Text('Error buying ingredients'),
                          content: Text('No recipes selected for buying ingredients'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            )
                          ],
                        );
                      });
                } else {
                  _updateIngredientsForSelectedRecipes(_selectedRecipes, 1);
                  _selectedRecipes = [];
                }
              },
              child: Text(
                'Buy Ingredients',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
