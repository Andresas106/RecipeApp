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
  final ingredientController = IngredientController();

  Future<List<Ingredient>> _getSuggestions(String query) async{
    print(ingredientController.fetchIngredientsBySearch(query).toString());
    return await ingredientController.fetchIngredientsBySearch(query);
  }

  void _addIngredients(Ingredient ingredient){
    if(!_selectedIngredients.contains(ingredient))
    {
      setState(() {
        _selectedIngredients.add(ingredient);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final TextEditingController titleControler = TextEditingController();
    final TextEditingController descriptionControler = TextEditingController();
    TextEditingController searchController = TextEditingController();


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
                  SizedBox(height: 20,),
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
                  SizedBox(height: 20,),
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
                  SizedBox(height: 20,),
                  Autocomplete<Ingredient>(
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      if(textEditingValue.text == '') return const Iterable<Ingredient>.empty();
                      return await _getSuggestions(textEditingValue.text);
                    },
                    displayStringForOption: (Ingredient option) => option.name,
                    onSelected: (Ingredient selection) {
                      _addIngredients(selection);
                      searchController.clear();
                      FocusScope.of(context).unfocus();
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
                  SizedBox(height: 20,),
                  Text('Selected Ingredients', style: TextStyle(fontWeight: FontWeight.bold),),
                  Expanded(
                      child: ListView.builder(
                          itemCount: _selectedIngredients.length,
                          itemBuilder: (context, index) {
                            final ingredient = _selectedIngredients[index];
                            return ListTile(
                                title: Text(ingredient.name),
                                subtitle: Text(ingredient.description),
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedIngredients.removeAt(index);
                                    });
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                )
                            );
                          })
                  )
                ],
              ),
            )

          )

      ),

    );
  }
}