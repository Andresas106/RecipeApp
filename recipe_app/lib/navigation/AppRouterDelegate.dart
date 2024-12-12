import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/IntroScreen.dart';

class AppRouterDelegate extends RouterDelegate<RouteSettings>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteSettings> {
  final GlobalKey<NavigatorState> navigatorKey;
  RouteSettings? _currentRoute;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  RouteSettings? get currentConfiguration => _currentRoute;

  void _setNewRoutePath(RouteSettings settings) {
    _currentRoute = settings;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(RouteSettings configuration) {
    _setNewRoutePath(configuration);
    return SynchronousFuture<void>(null);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        CustomTransitionPage(key: ValueKey('IntroScreen'),
            child: IntroScreen()),
        if(_currentRoute?.name == '/login')
          CustomTransitionPage(key: ValueKey('LoginScreen'),child: LoginScreen()),
        /*if(_currentRoute?.name == '/products')
          CustomTransitionPage(key: ValueKey('ProductsScreen'),child: ProductListScreen()),
        if(_currentRoute?.name == '/productDetail')
          CustomTransitionPage(key: ValueKey('ProductDetailScreen'), child: ProductDetailScreen(_currentRoute!.arguments as Product)),*/
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        /*if(_currentRoute?.name == '/productDetail')
          {
            _setNewRoutePath(RouteSettings(name: '/products'));
          }
        else if(_currentRoute?.name == '/products')
          {
            _setNewRoutePath(RouteSettings(name: '/login'));
          }
        else
          {
            _setNewRoutePath(RouteSettings(name: '/'));
          }*/

        return true;
      },
    );
  }
}

class CustomTransitionPage extends Page {
  final Widget child;

  CustomTransitionPage({required LocalKey key,required  this.child})
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