import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/utils/authService.dart';

import '../navigation/AppRouterDelegate.dart';

class NewRecipeScreen extends StatelessWidget {
  const NewRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();

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
              )
            ],
          ),
        )

      ),

    );
  }

}