import 'package:flutter/material.dart';

import '../utils/authService.dart';

class Registerscreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30,),
            Text('Registration', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal[700]),
            ),
            const SizedBox(height: 10,),
            Text('Please register to create your account', style:  TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                  )),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),),
              obscureText: true,
            ),
            const SizedBox(height: 20),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white),)
            ),
          ],
        ),
      ),
    );
  }
}
