import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/model/ingredients.dart';
import 'package:recipe_app/utils/authService.dart';

import '../navigation/AppRouterDelegate.dart';



class NewRecipeScreen extends StatefulWidget {
  @override
  _NewRecipeScreenState createState() => _NewRecipeScreenState();

}

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  final List<Ingredient> _selectedIngredients = [];

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final TextEditingController titleControler = TextEditingController();
    final TextEditingController descriptionControler = TextEditingController();


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
          child: Center(
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
                SizedBox(height: 10,),
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
              ],
            ),
          )

      ),

    );
  }
}