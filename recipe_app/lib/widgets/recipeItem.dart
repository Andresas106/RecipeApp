import 'package:flutter/material.dart';
import 'package:recipe_app/controller/recipeController.dart';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/utils/imageProcessing.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;
  final Function(String) onDelete;

  const RecipeItem({required this.recipe, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    final RecipeController recipeController = RecipeController();

    return GestureDetector(
      onTap: () {
        final routerDelegate = Router.of(context).routerDelegate;
        routerDelegate.setNewRoutePath(RouteSettings(name: '/recipedetail', arguments: recipe));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 80,
                height: 80,
                child: ImageProcessing.base64ToImageWidget(recipe.image),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  recipeController.deleteRecipe(recipe.id);
                  onDelete(recipe.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
