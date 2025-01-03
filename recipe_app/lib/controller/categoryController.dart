import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/category.dart';


class CategoryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> fetchCategory() async {
    List<Category> categorias = [];

    try {
      QuerySnapshot snapshot = await _firestore.collection('categories').get();

      for(var doc in snapshot.docs)
      {
        Category category = Category.fromJson(doc.data() as Map<String, dynamic>);
        categorias.add(category);
      }
    }catch(e)
    {
      print('Error al leer las categorias: $e');
    }

    return categorias;
  }
}