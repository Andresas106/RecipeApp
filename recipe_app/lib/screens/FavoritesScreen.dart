import 'package:flutter/material.dart';
import 'package:recipe_app/controller/favoritesController.dart';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/widgets/recipeItem.dart';

import '../controller/recipeController.dart';
import '../navigation/AppRouterDelegate.dart';
import '../utils/authService.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final recipeController = RecipeController();
  List<Recipe> _recipesList = [];

  @override
  void initState() {
    super.initState();
    _getRecipes();
  }

  Future<void> _getRecipes() async {
    final recipes = await recipeController.fetchRecipes();
    final favoriteIds = await FavoritesController.getFavorites();

    final favoriteRecipes = recipes.where((recipe) => favoriteIds.contains(recipe.id)).toList();

    setState(() {
      _recipesList = favoriteRecipes;
    });
  }

  void _deleteRecipeById(String id) {
    FavoritesController.deleteRecipe(id);
    setState(() {
      _recipesList.removeWhere((recipe) => recipe.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                _authService.logout();
                final routerDelegate =
                Router.of(context).routerDelegate as AppRouterDelegate;
                routerDelegate.setNewRoutePath(RouteSettings(name: '/login'));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ListView.separated(
            itemCount: _recipesList.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 20,),
            itemBuilder: (ctx, i) => RecipeItem(
              recipe: _recipesList[i],
              onDelete: _deleteRecipeById,
            ),
          )),
    );
  }
}
