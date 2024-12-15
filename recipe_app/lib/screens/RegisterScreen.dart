import 'package:flutter/material.dart';

import '../utils/authService.dart';

class Registerscreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                final user =
                await _authService.registerWithEmail(email, password);
                if (user != null) {
                  Navigator.pop(context);
                } else {
                  showDialog(context: context, builder: (BuildContext builder) {
                    return AlertDialog(
                      title: Text('Registration Failed'),
                      content: Text('Invalid username or password for the registration. Please try again.'),
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
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
