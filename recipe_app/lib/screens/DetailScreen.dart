import 'package:flutter/material.dart';
import 'package:recipe_app/controller/favoritesController.dart';
import '../controller/recipeController.dart';
import '../model/recipe.dart';
import '../navigation/AppRouterDelegate.dart';
import '../utils/authService.dart';
import '../utils/imageProcessing.dart';

class DetailScreen extends StatefulWidget {
  final Recipe recipe;

  const DetailScreen(this.recipe, {super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final AuthService _authService = AuthService();
  final RecipeController _recipeController = RecipeController();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _verifyFavorite();
  }

  Future<void> _verifyFavorite() async {
    final isFavorite = await FavoritesController.isfavorite(widget.recipe.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  Future<void> _switchFavorite() async {
    if(_isFavorite) {
      await FavoritesController.deleteRecipe(widget.recipe.id);
    } else {
      await FavoritesController.addFavorite(widget.recipe.id);
    }
    _verifyFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.recipe.title}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: _switchFavorite,
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.grey,
      )
    ),
          IconButton(onPressed: () {
            final routerDelegate = Router.of(context).routerDelegate as AppRouterDelegate;
            routerDelegate.setNewRoutePath(RouteSettings(name: '/updaterecipe', arguments: widget.recipe));
          }, icon: Icon(Icons.edit)),
          IconButton(
            onPressed: () {
              _recipeController.deleteRecipe(widget.recipe.id);
              final routerDelegate = Router.of(context).routerDelegate as AppRouterDelegate;
              routerDelegate.setNewRoutePath(RouteSettings(name: '/recipes'));
            },
            icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              _authService.logout();
              final routerDelegate =
              Router.of(context).routerDelegate as AppRouterDelegate;
              routerDelegate.setNewRoutePath(RouteSettings(name: '/login'));
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            ImageProcessing.base64ToImageWidget(widget.recipe.image),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title and Description
                  Text(
                    widget.recipe.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.recipe.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),
                  // Ingredients
                  Card(
                    margin: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ingredients:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                            SizedBox(height: 8),
                            for (var ingredient in widget.recipe.ingredients)
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "- ${ingredient.name} (${widget.recipe.ingredientQuantities[ingredient] ?? 0})",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      ingredient.stock > 0 ? "With stock" : "Without stock",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: ingredient.stock > 0 ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.teal, thickness: 1),
                  SizedBox(height: 16),
                  // Preparation Steps
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preparation Steps:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          for (var step in widget.recipe.preparation_steps)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                "- $step",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.teal, thickness: 1),
                  SizedBox(height: 16),
                  // Time and Difficulty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.timer, color: Colors.teal),
                          SizedBox(width: 8),
                          Text(
                            '${widget.recipe.time} mins',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.whatshot, color: Colors.teal),
                          SizedBox(width: 8),
                          Text(
                            widget.recipe.difficulty.displayName,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Category
                  Row(
                    children: [
                      Icon(Icons.category, color: Colors.teal),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${widget.recipe.category.name}',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.teal[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
