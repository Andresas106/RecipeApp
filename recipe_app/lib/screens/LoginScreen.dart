import 'package:flutter/material.dart';

import '../navigation/AppRouterDelegate.dart';
import '../utils/authService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  final user = await _authService.loginWithEmail(email, password);
                  if(user == null)
                    {
                      showDialog(context: context, builder: (BuildContext builder) {
                        return AlertDialog(
                          title: Text('Login Failed'),
                          content: Text('Invalid username or password. Please try again.'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'))
                          ],
                        );
                      });
                    }
                  else {
                    final routerDelegate = Router.of(context).routerDelegate as AppRouterDelegate;
                    routerDelegate.setNewRoutePath(RouteSettings(name: '/recipes'));
                  }
                },
                child: Text('Login')
            ),
            ElevatedButton(
                onPressed: () async {
                  final user = await _authService.loginWithGoogle();
                  if(user == null)
                    {
                      showDialog(context: context, builder: (BuildContext builder) {
                        return AlertDialog(
                          title: Text('Login Failed'),
                          content: Text('Invalid login with Google. Please try again.'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'))
                          ],
                        );
                      });
                    }
                  else
                    {
                      final routerDelegate = Router.of(context).routerDelegate as AppRouterDelegate;
                      routerDelegate.setNewRoutePath(RouteSettings(name: '/recipes'));
                    }
                },
                child: Text('Login with Google')
            ),
            TextButton(
                onPressed: () {
                  final routerDelegate = Router.of(context).routerDelegate;
                  routerDelegate.setNewRoutePath(RouteSettings(name: '/register'));
                },
                child: Text('Don\'t have account? Create one')
            ),
          ],
        ),
      ),
    );

  }
}
