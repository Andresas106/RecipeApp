import 'package:flutter/material.dart';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/widgets/recipeItem.dart';

import '../controller/recipeController.dart';
import '../navigation/AppRouterDelegate.dart';
import '../utils/authService.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final recipeController = RecipeController();
  List<Recipe> _recipesList = [];

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

  void _deleteRecipeById(String id) {
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
          'Recipes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                final routerDelegate =
                    Router.of(context).routerDelegate as AppRouterDelegate;
                routerDelegate
                    .setNewRoutePath(RouteSettings(name: '/newrecipe'));
              },
              icon: Icon(Icons.add)),
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
