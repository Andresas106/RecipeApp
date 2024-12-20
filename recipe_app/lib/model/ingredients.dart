class Ingredient {
  final int _id;
  final String _name;
  final String _description;
  final int _stock;

  Ingredient({
    required int id,
    required String name,
    required String description,
    required int stock
  })  : _name = name,
        _description = description,
        _id = id,
        _stock = stock;

  String get name => _name;
  String get description => _description;
  int get id => _id;
  int get stock => _stock;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Ingredient) return false;
    return other.id == id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;


  //Get information from Firebase
  factory Ingredient.fromJson(Map<String, dynamic> data)
  {
    return Ingredient(
        id: data['id'],
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        stock: data['stock']
    );
  }

  //Save information to Firebase
  Map<String, dynamic> toJson()
  {
    return {
      'id' : _id,
      'name' : _name,
      'description' : _description,
      'stock' : _stock
    };
  }
}