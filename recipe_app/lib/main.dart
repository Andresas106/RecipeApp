import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/controller/ingredientController.dart';

import 'model/ingredients.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final IngredientController ic = IngredientController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirestoreTestScreen(ingredientManager: ic,),
    );
  }
}

class FirestoreTestScreen extends StatefulWidget {
  final IngredientController ingredientManager;

  FirestoreTestScreen({required this.ingredientManager});

  @override
  _FirestoreTestScreenState createState() => _FirestoreTestScreenState();
}

class _FirestoreTestScreenState extends State<FirestoreTestScreen> {
  late Future<List<Ingredient>> _ingredientsFuture;

  @override
  void initState() {
    super.initState();
    // Cargar los ingredientes al iniciar la pantalla
    _ingredientsFuture = widget.ingredientManager.fetchIngredients();
  }

  void _addIngredient() {
    Ingredient newIngredient = Ingredient(
      id: '', // El id será generado automáticamente por IngredientManager
      name: 'Sal',
      description: 'Ingrediente común en todas las cocinas.',
    );

    widget.ingredientManager.addIngredient(newIngredient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ingredientes en Firestore')),
      body: FutureBuilder<List<Ingredient>>(
        future: _ingredientsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay ingredientes disponibles.'));
          }

          // Lista de ingredientes
          List<Ingredient> ingredients = snapshot.data!;

          return ListView.builder(
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              Ingredient ingredient = ingredients[index];
              return ListTile(
                title: Text(ingredient.name),
                subtitle: Text(ingredient.description),
                trailing: Text(ingredient.id), // Mostrar el ID si es necesario
              );
            },
          );
        },
      ),
    );
  }
}
