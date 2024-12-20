import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/controller/ingredientController.dart';
import 'package:recipe_app/model/ingredients.dart';
import 'package:recipe_app/utils/authService.dart';

import '../navigation/AppRouterDelegate.dart';



class NewRecipeScreen extends StatefulWidget {
  @override
  _NewRecipeScreenState createState() => _NewRecipeScreenState();

}

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  final List<Ingredient> _selectedIngredients = [];
  final Map<Ingredient, int> _quantitiesIngredients = {};
  final List<String> _preparationSteps = [];
  final ingredientController = IngredientController();

  Future<List<Ingredient>> _getSuggestions(String query) async{
    return await ingredientController.fetchIngredientsBySearch(query);
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

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final TextEditingController titleControler = TextEditingController();
    final TextEditingController descriptionControler = TextEditingController();
    TextEditingController searchController = TextEditingController();
    final TextEditingController timeController = TextEditingController();


    return Scaffold(
      appBar: AppBar(
        title: Text('New Recipe', style: TextStyle(color: Colors.white),),
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
          padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 48),
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Column(
                children: [
                  const SizedBox(height: 30,),
                  Text('Add new Recipe', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal[700]),
                  ),
                  const SizedBox(height: 20,),
                  Text('Refill the form to add a new recipe', style:  TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30,),
                  TextField(
                    controller: titleControler,
                    decoration: InputDecoration(
                        labelText: 'Title',
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)
                        )),
                  ),
                  const SizedBox(height: 20,),
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
                  const SizedBox(height: 20,),
                  Autocomplete<Ingredient>(
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      if(textEditingValue.text == '') return const Iterable<Ingredient>.empty();
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
                            prefixIcon: Icon(Icons.search)
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20,),
                  const Text('Selected Ingredients', style: TextStyle(fontWeight: FontWeight.bold),),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _selectedIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = _selectedIngredients[index];
                      final quantity = _quantitiesIngredients[ingredient] ?? 1;
                      return ListTile(
                          title: Text('${ingredient.name} - x${quantity}',
                          ),
                          subtitle: Text(ingredient.description),
                          trailing: IconButton(
                            onPressed: () {
                              setState( () {
                                _selectedIngredients.removeAt(index);
                                _quantitiesIngredients.remove(ingredient);
                              });
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          )
                      );
                    }
                  ),
                  const SizedBox(height: 20,),
                  const Text('Preparation Steps', style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._preparationSteps.asMap().entries.map((entry) {
                    int index = entry.key;
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: -24 ),
                      title: TextField(
                        onChanged: (value) => _updatePreparationStep(index, value), // Actualizar paso
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
                        onPressed: () => _removePreparationSteps(index), // Eliminar paso
                      ),

                    );
                  }).toList(),
                  ElevatedButton(
                      onPressed: _addPreparationSteps,
                      child: Text('Add Step')),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: timeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Time (minutes)',
                        prefixIcon: Icon(Icons.timelapse),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)
                        )),
                  ),
                ],
              ),
            )

          )

      ),

    );
  }
}