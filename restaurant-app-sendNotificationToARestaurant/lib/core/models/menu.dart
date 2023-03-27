class Menu {
  final String id;
  List<MenuSection>? menuSections;
  List<String> menuImages;
  final String? note;
  final DateTime createdAt;

  Menu({
    required this.id,
    required this.createdAt,
    required this.menuImages,
    this.note,
  });

  Menu.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        createdAt = json['createdAt'],
        note = json['note'],
        menuImages = List<String>.from(json['menuImages']),
        menuSections = [
          for (var menuSection in json['menuSection'])
            MenuSection.fromJson(menuSection)
        ];
  // .sort((a, b) => a.position.compareTo(b.position))
}

class MenuSection {
  String? id;
  String? name;
  int? position;
  List<MenuItem>? menuItems;

  MenuSection({required this.id, required this.menuItems});

  MenuSection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    menuItems = [
      for (var menuItem in json['items']) MenuItem.fromJson(menuItem)
    ];
  }
}

class MenuItem {
  String? id;
  String? alias;
  String? idDish;
  String? imageUrl;
  String? imageUrl200;
  double? price;
  String? description;
  String? imageHash;
  String? sectionId;

  MenuItem(
      {this.id,
      this.alias,
      this.price,
      this.description,
      this.idDish,
      this.imageUrl,
      this.imageUrl200,
      this.imageHash,
      this.sectionId});

  MenuItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alias = json['alias'];
    idDish = json['idDish'];
    imageUrl = json['imageUrl1000'];
    imageUrl200 = json['imageUrl1000'];
    imageHash = json['imageHash'];
    price = json['price'].toDouble();
    description = json['description'];
    sectionId = json['sectionId'];
  }
}
