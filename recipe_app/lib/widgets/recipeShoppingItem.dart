import 'package:flutter/material.dart';
import 'package:recipe_app/model/recipe.dart';
import '../model/ingredients.dart';

class RecipeShoppingItem extends StatelessWidget {
  final Recipe recipe;
  final bool isSelected;
  final ValueChanged<bool?> onSelectedChanged;

  const RecipeShoppingItem({
    required this.recipe,
    required this.isSelected,
    required this.onSelectedChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            ),
          ],
        ),
        child: Stack(
          children: [
            // Contenido principal
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: recipe.ingredients.length,
                  itemBuilder: (context, index) {
                    final Ingredient ingredient = recipe.ingredients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ingredient.name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${ingredient.stock}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.inventory, // Replace this with the icon you want
                                color: Colors.grey[700],
                                size: 20, // Set the icon size
                              ),

                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            // Checkbox en la parte superior derecha
            Positioned(
              top: 0,
              right: 0,
              child: Checkbox(
                value: isSelected,
                onChanged: onSelectedChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
