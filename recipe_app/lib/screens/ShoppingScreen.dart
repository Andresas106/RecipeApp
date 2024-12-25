import 'package:flutter/material.dart';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/widgets/recipeItem.dart';

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
                final routerDelegate =
                Router.of(context).routerDelegate as AppRouterDelegate;
                routerDelegate.setNewRoutePath(RouteSettings(name: '/login'));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container()
      )
    );
  }
}
