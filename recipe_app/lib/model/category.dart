class Category {
  final int _id;
  final String _name;
  final String _description;

  Category({
    required int id,
    required String name,
    required String description,
  })  : _name = name,
        _description = description,
        _id = id;

  String get name => _name;
  String get description => _description;
  int get id => _id;


  //Get information from Firebase
  factory Category.fromJson(Map<String, dynamic> data)
  {
    return Category(
        id: data['id'],
        name: data['name'] ?? '',
        description: data['description'] ?? '');
  }

  //Save information to Firebase
  Map<String, dynamic> toJson()
  {
    return {
      'id' : _id,
      'name' : _name,
      'description' : _description,
    };
  }

  // Sobrescribir el operador == para que compare los objetos por sus propiedades
  @override
  bool operator ==(Object other) {
    // Verificar que sea la misma clase y comparar sus propiedades
    if (identical(this, other)) return true;
    if (other is! Category) return false;
    return other.id == id && other.name == name;
  }

  // Sobrescribir hashCode para que sea consistente con el operador ==
  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}