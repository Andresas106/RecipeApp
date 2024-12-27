import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/recipe.dart';

class AppRouteInformationParser extends RouteInformationParser<RouteSettings> {
  @override
  Future<RouteSettings> parseRouteInformation(RouteInformation routeInformation) async {

    final uri = routeInformation.uri;
    if(uri.pathSegments.length == 1 && uri.pathSegments[0] == 'login') return RouteSettings(name: '/login');
    if(uri.pathSegments.length == 1 && uri.pathSegments[0] == 'register') return RouteSettings(name: '/register');
    if(uri.pathSegments.length == 1 && uri.pathSegments[0] == 'recipes') return RouteSettings(name: '/recipes');
    if(uri.pathSegments.length == 1 && uri.pathSegments[0] == 'newrecipe') return RouteSettings(name: '/newrecipe');
    if(uri.pathSegments.length == 1 && uri.pathSegments[0] == 'favorites') return RouteSettings(name: '/favorites');
    if(uri.pathSegments.length == 2 && uri.pathSegments[0] == 'detailrecipe') {
      final recipeJsonString = uri.pathSegments[1];
      final recipe = Recipe.fromJsonString(recipeJsonString);
      return RouteSettings(name: '/recipedetail', arguments: recipe);
    }
    if(uri.pathSegments.length == 2 && uri.pathSegments[0] == 'updaterecipe') {
      final recipeJsonString = uri.pathSegments[1];
      final recipe = Recipe.fromJsonString(recipeJsonString);
      return RouteSettings(name: '/updaterecipe', arguments: recipe);
    }
    if(uri.pathSegments.length == 1 && uri.pathSegments[0] == 'shopping') return RouteSettings(name: '/shopping');
    /*if(uri.pathSegments.length == 2 && uri.pathSegments[0] == 'productDetail'){
      final productJsonString = uri.pathSegments[1];
      final product = Product.fromJsonString(productJsonString);
      return RouteSettings(name: '/productDetail', arguments: product);
    }*/
    return RouteSettings(name: '/');
  }

  @override
  RouteInformation? restoreRouteInformation(RouteSettings configuration)
  {
    if (configuration.name == '/recipedetail') {
      final recipe = configuration.arguments as Recipe;
      final recipeJsonString = recipe.toJsonString();
      return RouteInformation(uri: Uri.parse('/productDetail/$recipeJsonString'));
    }

    if (configuration.name == '/updaterecipe') {
      final recipe = configuration.arguments as Recipe;
      final recipeJsonString = recipe.toJsonString();
      return RouteInformation(uri: Uri.parse('/updaterecipe/$recipeJsonString'));
    }
    return RouteInformation(uri: Uri.parse(configuration.name ?? '/'));
  }
}