class Ingredient {
  final String _id;
  final String _name;
  final String _description;

  Ingredient({
    required String id,
    required String name,
    required String description,
  })  : _name = name,
        _description = description,
        _id = id;

  String get name => _name;
  String get description => _description;
  String get id => _id;


  //Get information from Firebase
  factory Ingredient.fromJson(String id, Map<String, dynamic> data)
  {
    return Ingredient(
        id: id,
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
}