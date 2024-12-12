import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controller/recipeController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final RecipeController recipeController = RecipeController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirestoreTestScreen(recipeController: recipeController),
    );
  }
}

class FirestoreTestScreen extends StatefulWidget {
  final RecipeController recipeController;

  FirestoreTestScreen({required this.recipeController});

  @override
  _FirestoreTestScreenState createState() => _FirestoreTestScreenState();
}

class _FirestoreTestScreenState extends State<FirestoreTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prueba de Recetas')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await widget.recipeController.addRecipe();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Receta añadida a Firestore.')),
            );
          },
          child: Text('Añadir Receta de Prueba'),
        ),
      ),
    );
  }
}
