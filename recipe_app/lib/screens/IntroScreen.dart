import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipe_app/navigation/AppRouterDelegate.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(Duration(seconds: 3), () {
      final routerDelegate = Router.of(context).routerDelegate as AppRouterDelegate;
      routerDelegate.setNewRoutePath(RouteSettings(name: '/login'));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/intro_image.jpg', fit: BoxFit.cover,),
          ),
          Center(
            child: Text(
              'Recipe Application',
              textAlign: TextAlign.center,
              style: textTheme.displayLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
