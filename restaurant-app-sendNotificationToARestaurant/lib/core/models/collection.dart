class Collection {
  final String? id;
  final List<String>? restaurantIds;
  final String? title;
  final String? color;
  final bool? isDefault;
  // final DateTime? createdAt;
  final int? nbPlaces;

  const Collection({
    this.id,
    this.title,
    this.color = "colors.orange",
    this.restaurantIds,
    this.isDefault = false,
    // this.createdAt,
    this.nbPlaces = 0,
  });

  Collection.fromJson(Map<String, dynamic> data, String id)
      : id = id,
        restaurantIds = List<String>.from(data['restaurantIds']),
        title = data['title'],
        color = data['color'],
        isDefault = data['isDefault'],
        // createdAt = data['createdAt'],
        nbPlaces = data['restaurantIds'].length;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['color'] = this.color;
    data['isDefault'] = this.isDefault;
    // data['createdAt'] = this.createdAt;
    data['restaurantIds'] = this.restaurantIds;
    data['nbPlaces'] = this.nbPlaces;
    return data;
  }
}
