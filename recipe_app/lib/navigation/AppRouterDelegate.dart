import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipe_app/screens/NewRecipeScreen.dart';
import 'package:recipe_app/screens/RecipesScreen.dart';
import 'package:recipe_app/screens/RegisterScreen.dart';

import '../screens/IntroScreen.dart';
import '../screens/LoginScreen.dart';

class AppRouterDelegate extends RouterDelegate<RouteSettings>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteSettings> {
  final GlobalKey<NavigatorState> navigatorKey;
  RouteSettings? _currentRoute = RouteSettings(name: '/');

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  RouteSettings? get currentConfiguration => _currentRoute;

  void _setNewRoutePath(RouteSettings settings) {
    _currentRoute = settings;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(RouteSettings configuration) async {
    _setNewRoutePath(configuration);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
       // if(_currentRoute?.name == '/')
          CustomTransitionPage(key: ValueKey('IntroScreen'),
              child: IntroScreen()),
        if(_currentRoute?.name == '/login')
          CustomTransitionPage(key: ValueKey('LoginScreen'),child: LoginScreen()),
        if(_currentRoute?.name == '/register')
          CustomTransitionPage(key: ValueKey('RegisterScreen'),child: Registerscreen()),
        if(_currentRoute?.name == '/recipes')
          CustomTransitionPage(key: ValueKey('RecipesScreen'), child: RecipesScreen()),
        if(_currentRoute?.name == '/newrecipe')
          CustomTransitionPage(key: ValueKey('NewRecipeScreen'), child: NewRecipeScreen()),
        /*if(_currentRoute?.name == '/productDetail')
          CustomTransitionPage(key: ValueKey('ProductDetailScreen'), child: ProductDetailScreen(_currentRoute!.arguments as Product)),*/
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        if(_currentRoute?.name == '/register' || _currentRoute?.name == '/recipes')
        {
          _setNewRoutePath(RouteSettings(name: '/login'));
        }
        else if(_currentRoute?.name == '/login') {
           exit(0);
        }
        else if(_currentRoute?.name == '/newrecipe')
        {
          _setNewRoutePath(RouteSettings(name: '/recipes'));
        }

        return true;
      },
    );
  }
}

class CustomTransitionPage extends Page {
  final Widget child;

  const CustomTransitionPage({required LocalKey key,required  this.child})
  : super(key: key);
  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        settings: this,
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child,);
        }
    );
  }
}