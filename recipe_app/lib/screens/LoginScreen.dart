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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              Text('Welcome', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal[700]),
              ),
              const SizedBox(height: 10,),
              Text('Please login to your account', style:  TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30,),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 20,),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white),)
              ),
              const SizedBox(height: 20,),
              ElevatedButton.icon(
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white70,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                icon: Icon(Icons.g_mobiledata, size: 40,),
                label: const Text(
                  'Login with Google',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20,),
              TextButton(
                  onPressed: () {
                    final routerDelegate = Router.of(context).routerDelegate;
                    routerDelegate.setNewRoutePath(RouteSettings(name: '/register'));
                  },
                  child: Text('Don\'t have account? Create one', style: TextStyle(fontSize: 16, color: Colors.teal, decoration: TextDecoration.underline),
                  ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
