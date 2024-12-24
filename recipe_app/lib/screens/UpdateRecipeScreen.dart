import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/controller/categoryController.dart';
import 'package:recipe_app/controller/ingredientController.dart';
import 'package:recipe_app/controller/recipeController.dart';
import 'package:recipe_app/model/ingredients.dart';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/utils/authService.dart';

import '../model/category.dart';
import '../navigation/AppRouterDelegate.dart';
import '../utils/imageProcessing.dart';

class UpdateRecipeScreen extends StatefulWidget {
  final Recipe recipe;

  UpdateRecipeScreen({required this.recipe});

  @override
  _UpdateRecipeScreenState createState() => _UpdateRecipeScreenState();
}

class _UpdateRecipeScreenState extends State<UpdateRecipeScreen> {
  final List<Ingredient> _selectedIngredients = [];
  final Map<Ingredient, int> _quantitiesIngredients = {};
  final List<String> _preparationSteps = [];
  final categoryController = CategoryController();
  final ingredientController = IngredientController();
  final recipeController = RecipeController();
  Difficulty? _selectedDifficulty;
  List<Category> _categoriesList = [];
  Category? _selectedCategory;
  File? selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController titleControler = TextEditingController();
  final TextEditingController descriptionControler = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  Future<List<Ingredient>> _getSuggestions(String query) async{
    return await ingredientController.fetchIngredientsBySearch(query);
  }

  Future<void> _getCategories() async {
    _categoriesList = await categoryController.fetchCategory();
    print(_categoriesList);
  }

  void _addIngredients(Ingredient ingredient){
    if(!_selectedIngredients.contains(ingredient))
    {
      TextEditingController quantityController = TextEditingController();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Set quantity for ${ingredient.name}'),
              content: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    prefixIcon: Icon(Icons.numbers),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                  )
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      int quantity = int.tryParse(quantityController.text) ?? 1;
                      setState(() {
                        _selectedIngredients.add(ingredient);
                        _quantitiesIngredients[ingredient] = quantity;
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Add'))
              ],
            );
          });
    }
    else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error adding ingredient'),
              content: Text('The ingredient ${ingredient.name} is already in the list'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'))
              ],
            );
          });
    }
  }

  void _addPreparationSteps()
  {
    setState(() {
      _preparationSteps.add('');
    });
  }

  void _removePreparationSteps(int index)
  {
    setState(() {
      _preparationSteps.removeAt(index);
    });
  }

  void _updatePreparationStep(int index, String step){
    setState(() {
      _preparationSteps[index] = step;
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    if(pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  void showErrorMessage(String message, BuildContext context)
  {
    showDialog(context: context, builder: (BuildContext builder) {
      return AlertDialog(
        title: Text('Recipe Update error'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'))
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    final recipe = widget.recipe;
    titleControler.text = recipe.title;
    descriptionControler.text = recipe.description;
    timeController.text = recipe.time.toString();
    _selectedDifficulty = recipe.difficulty;
    _selectedCategory = recipe.category;
    _preparationSteps.addAll(recipe.preparation_steps);
    _selectedIngredients.addAll(recipe.ingredients);
    _quantitiesIngredients.addAll(recipe.ingredientQuantities);
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Recipe', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {
            _authService.logout();
            final routerDelegate = Router.of(context).routerDelegate as AppRouterDelegate;
            routerDelegate.setNewRoutePath(RouteSettings(name: '/login'));
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                'Update Recipe',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal[700]),
              ),
              const SizedBox(height: 20),
              Text(
                'Refill the form to update the recipe',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: titleControler,
                decoration: InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    )),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: descriptionControler,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    )),
              ),
              const SizedBox(height: 20),
              Autocomplete<Ingredient>(
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text == '') return const Iterable<Ingredient>.empty();
                  return await _getSuggestions(textEditingValue.text);
                },
                displayStringForOption: (Ingredient option) => option.name,
                onSelected: (Ingredient selection) {
                  _addIngredients(selection);
                  searchController.clear();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  searchController = controller;

                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    decoration: InputDecoration(
                      labelText: "Search for Ingredients",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text('Selected Ingredients', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: _selectedIngredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = _selectedIngredients[index];
                    final quantity = _quantitiesIngredients[ingredient] ?? 1;
                    return ListTile(
                      title: Text('${ingredient.name} - x${quantity}'),
                      subtitle: Text(ingredient.description),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedIngredients.removeAt(index);
                            _quantitiesIngredients.remove(ingredient);
                          });
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    );
                  }
              ),
              const SizedBox(height: 20),
              const Text('Preparation Steps', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ..._preparationSteps.asMap().entries.map((entry) {
                int index = entry.key;
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: -24 ),
                  title: TextField(
                    onChanged: (value) => _updatePreparationStep(index, value),
                    decoration: InputDecoration(
                      labelText: 'Step ${index + 1}',
                      prefixIcon: Icon(Icons.fastfood),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removePreparationSteps(index),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPreparationSteps,
                child: Text('Add Step', style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Time (minutes)',
                    prefixIcon: Icon(Icons.timer),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                    )),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Difficulty>(
                  value: _selectedDifficulty,
                  hint: Text('Select a difficulty'),
                  items: Difficulty.values.map((Difficulty difficulty) {
                    return DropdownMenuItem<Difficulty>(
                      value: difficulty,
                      child: Text(difficulty.displayName),
                    );
                  }).toList(),
                  onChanged: (Difficulty? newValue) {
                    setState(() {
                      _selectedDifficulty = newValue!;
                    });
                  },
                  isExpanded: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.whatshot),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)
                      )
                  )
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  hint: Text('Select a category'),
                  items: _categoriesList.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (Category? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  isExpanded: true,
                  menuMaxHeight: 200,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.category_sharp),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)
                      )
                  )
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                label: const Text('Select image', style: TextStyle(color: Colors.white, fontSize: 18)),
                icon: Icon(Icons.image, color: Colors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (selectedImage != null)
                Column(
                  children: [
                    const Text("Selected Image:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Image.file(
                      selectedImage!,
                      height: 150,
                    ),
                  ],
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool hasValidInputs = titleControler.text.trim().isNotEmpty &&
                      descriptionControler.text.trim().isNotEmpty &&
                      _selectedIngredients.isNotEmpty &&
                      _quantitiesIngredients.isNotEmpty &&
                      _preparationSteps.isNotEmpty &&
                      timeController.text.trim().isNotEmpty &&
                      _selectedDifficulty != null &&
                      _selectedCategory != null &&
                      selectedImage != null;


                  if (hasValidInputs) {
                    bool arePreparationStepsValid = _preparationSteps.every((step) => step.trim().isNotEmpty);
                    if (arePreparationStepsValid) {
                      String base64Image = await ImageProcessing.imageFileToBase64(selectedImage!);
                      Recipe updatedRecipe = Recipe(
                          id: widget.recipe.id,  // Keep the same recipe ID
                          title: titleControler.text.trim(),
                          description: descriptionControler.text.trim(),
                          ingredients: _selectedIngredients,
                          ingredientQuantities: _quantitiesIngredients,
                          preparation_steps: _preparationSteps,
                          time: int.parse(timeController.text.trim()),
                          difficulty: _selectedDifficulty!,
                          image: base64Image,
                          category: _selectedCategory!);

                      recipeController.updateRecipe(updatedRecipe);

                      final routerDelegate = Router.of(context).routerDelegate;
                      routerDelegate.setNewRoutePath(RouteSettings(name: '/recipes'));
                    } else {
                      showErrorMessage('Don\'t leave the preparation steps empty.', context);
                    }
                  } else {
                    showErrorMessage('Please fill in all fields and select an image.', context);
                  }
                },
                child: const Text('Update Recipe', style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
