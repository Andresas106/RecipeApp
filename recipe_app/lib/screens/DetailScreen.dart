import 'package:flutter/material.dart';
import '../model/recipe.dart';
import '../navigation/AppRouterDelegate.dart';
import '../utils/authService.dart';

class DetailScreen extends StatefulWidget {
  final Recipe recipe;

  const DetailScreen(this.recipe, {super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.recipe.title}', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                
              }, 
              icon: Icon(Icons.edit)),
          IconButton(onPressed: () {
            
          }, icon: Icon(Icons.delete)),
          IconButton(onPressed: () {
            _authService.logout();
            final routerDelegate = Router.of(context).routerDelegate as AppRouterDelegate;
            routerDelegate.setNewRoutePath(RouteSettings(name: '/login'));
          }, icon: Icon(Icons.logout)),
        ],
      ),
    );
  }
}
