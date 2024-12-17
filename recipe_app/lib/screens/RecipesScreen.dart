import 'package:flutter/material.dart';

import '../navigation/AppRouterDelegate.dart';
import '../utils/authService.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {

  @override
  void initState() {
    super.initState();
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
    );

  }
}
