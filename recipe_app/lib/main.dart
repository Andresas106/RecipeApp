import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirestoreTestScreen(),
    );
  }
}

class FirestoreTestScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTestDocument() async {
    try {
      await _firestore.collection('testCollection').add({
        'message': 'Hello Firebase!',
        'timestamp': DateTime.now(),
      });
      print('Documento añadido correctamente.');
    } catch (e) {
      print('Error al añadir el documento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: addTestDocument,
          child: Text('Añadir Documento a Firestore'),
        ),
      ),
    );
  }
}
