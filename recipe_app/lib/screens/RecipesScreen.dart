import 'package:flutter/material.dart';
import 'package:recipe_app/model/recipe.dart';

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

  Future<void> _getRecipes() async{
    _recipesList = await recipeController.fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {
            final routerDelegate = Router.of(context).routerDelegate as AppRouterDelegate;
            routerDelegate.setNewRoutePath(RouteSettings(name: '/newrecipe'));
          }, icon: Icon(Icons.add)),
    
          IconButton(onPressed: () {
            _authService.logout();
            final routerDelegate = Router.of(context).routerDelegate as AppRouterDelegate;
            routerDelegate.setNewRoutePath(RouteSettings(name: '/login'));
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 48),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [

              ],
            ),
          ),
        ),
      )
    );

  }
}
