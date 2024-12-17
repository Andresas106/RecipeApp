import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppRouteInformationParser extends RouteInformationParser<RouteSettings> {
  @override
  Future<RouteSettings> parseRouteInformation(RouteInformation routeInformation) async {

    final uri = routeInformation.uri;
    if(uri.pathSegments.length == 1 && uri.pathSegments[0] == 'login') return RouteSettings(name: '/login');
    if(uri.pathSegments.length == 1 && uri.pathSegments[0] == 'register') return RouteSettings(name: '/register');
    if(uri.pathSegments.length == 1 && uri.pathSegments[0] == 'recipes') return RouteSettings(name: '/recipes');
    if(uri.pathSegments.length == 1 && uri.pathSegments[0] == 'newrecipe') return RouteSettings(name: '/newrecipe');
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
    /*if (configuration.name == '/productDetail') {
      final product = configuration.arguments as Product;
      final productJsonString = product.toJsonString();
      return RouteInformation(uri: Uri.parse('/productDetail/$productJsonString'));
    }*/
    return RouteInformation(uri: Uri.parse(configuration.name ?? '/'));
  }
}