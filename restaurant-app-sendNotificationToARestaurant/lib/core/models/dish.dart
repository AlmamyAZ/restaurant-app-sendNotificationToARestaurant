class Dish {
  final String? id;
  final String? foodGenericId;
  final String? name;
  int? likerCount;
  final String? speciality;
  final String? description;
  final String? ingredients;
  final DateTime? createdAt;
  final String? imageUrl;
  final String? imageHash;

  Dish({
    this.id,
    this.foodGenericId,
    this.name,
    this.likerCount,
    this.speciality,
    this.description,
    this.ingredients,
    this.createdAt,
    this.imageUrl,
    this.imageHash,
  });

  Dish.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        foodGenericId = json['foodGenericId'],
        name = json['name'],
        likerCount = json['likerCount'],
        speciality = json['speciality'],
        description = json['description'],
        ingredients = json['ingredients'],
        createdAt = json['createdAt'],
        imageUrl = json['imageUrl'],
        imageHash = json['imageHash'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['foodGenericId'] = this.foodGenericId;
    data['name'] = this.name;
    data['likerCount'] = this.likerCount;
    data['speciality'] = this.speciality;
    data['description'] = this.description;
    data['ingredients'] = this.ingredients;
    data['createdAt'] = this.createdAt;
    data['imageUrl'] = this.imageUrl;
    data['imageHash'] = this.imageHash;
    return data;
  }
}

var dishs = [
  {
    "id": "c0938ccmkk39c9c",
    "foodGenericId": "pizza",
    "name": "pizza végétarienne",
    "likerCount": 12,
    "speciality": "français",
    "description": "français français pizza végétarienne pour votre bien-être ",
    "ingredients": "tomate , farine ,....",
    "createdAt": DateTime.utc(2020, 03, 3),
    "imgUrl": ""
  },
  {
    "id": "9xo38ccmkk39c9c",
    "foodGenericId": "pizza",
    "name": "pizza végétarienne",
    "likerCount": 12,
    "speciality": "français",
    "description": "français français pizza végétarienne pour votre bien-être ",
    "ingredients": "tomate , farine ,....",
    "createdAt": DateTime.utc(2020, 03, 3),
    "imgUrl": ""
  },
  {
    "id": "x9138ccmkk39c9c",
    "foodGenericId": "pizza",
    "name": "pizza vegetarien",
    "likerCount": 12,
    "speciality": "français",
    "description": "francais fracais pizza vegetarien pour votre bien etre ",
    "ingredients": "tomate , farine ,....",
    "createdAt": DateTime.utc(2020, 03, 3),
    "imgUrl": ""
  },
  {
    "id": "0a238ccmkk39c9c",
    "foodGenericId": "pizza",
    "name": "pizza vegetarien",
    "likerCount": 12,
    "speciality": "français",
    "description": "francais fracais pizza vegetarien pour votre bien etre ",
    "ingredients": "tomate , farine ,....",
    "createdAt": DateTime.utc(2020, 03, 3),
    "imgUrl": ""
  },
  {
    "id": "l0338ccmkk39c9c",
    "foodGenericId": "pizza",
    "name": "pizza vegetarien",
    "likerCount": 12,
    "speciality": "français",
    "description": "francais fracais pizza vegetarien pour votre bien etre ",
    "ingredients": "tomate , farine ,....",
    "createdAt": DateTime.utc(2020, 03, 3),
    "imgUrl": ""
  },
  {
    "id": "0co38ccmkk39c9c",
    "foodGenericId": "pizza",
    "name": "pizza vegetarien",
    "likerCount": 12,
    "speciality": "français",
    "description": "francais fracais pizza vegetarien pour votre bien etre ",
    "ingredients": "tomate , farine ,....",
    "createdAt": DateTime.utc(2020, 03, 3),
    "imgUrl": ""
  },
  {
    "id": "3v338ccmkk39c9c",
    "foodGenericId": "pizza",
    "name": "pizza vegetarien",
    "likerCount": 12,
    "speciality": "français",
    "description": "francais fracais pizza vegetarien pour votre bien etre ",
    "ingredients": "tomate , farine ,....",
    "createdAt": DateTime.utc(2020, 03, 3),
    "imgUrl": ""
  },
];
