import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
        final routerDelegate = Router.of(context).routerDelegate;
        routerDelegate.setNewRoutePath(RouteSettings(name: '/login'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );

  }
}
