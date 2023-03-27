/// Products: A list of all the products with their options that the user would like to buy
/// Total: the current total of the cart
/// UserId: the user the cart belongs too
/// RestaurantId: The restaurant the orders are from
/// DeliveryLocation: The place to where the user is ordering the food

enum OrderTime { asap, later }

class Cart {
  String? id;
  List<Product>? products;
  double? total;
  String? userId;
  String? restaurantId;
  String? orderDeliveryTime;
  String? orderDeliveryDay;
  String? orderNote;
  OrderTime? orderTime;
  bool? isDelivery;

  Cart({
    this.id,
    this.products,
    this.total,
    this.userId,
    this.restaurantId,
    this.orderDeliveryTime,
    this.orderDeliveryDay,
    this.orderNote,
    this.orderTime = OrderTime.asap,
    this.isDelivery = true,
  });

  Cart.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        products = json['products'],
        total = json['total'],
        userId = json['userId'],
        restaurantId = json['restaurantId'],
        orderDeliveryDay = json['orderDeliveryDay'],
        orderDeliveryTime = json['orderDeliveryTime'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['products'] = this.products;
    data['total'] = this.total;
    data['userId'] = this.userId;
    data['restaurantId'] = this.restaurantId;
    data['orderDeliveryTime'] = this.orderDeliveryTime;
    data['orderDeliveryDay'] = this.orderDeliveryDay;
    data['orderNote'] = this.orderNote;
    data['orderTime'] = this.orderTime;
    data['isDelivry'] = this.isDelivery;
    return data;
  }

  void computeTotal() {
    this.total = this.products?.fold(
        0.0,
        (previousValue, element) =>
            previousValue! + (element.quantity! * element.price!));
  }
}

class Product {
  String? id;
  String? alias;
  double? price;
  int? quantity;

  Product({
    this.id,
    this.alias,
    this.price,
    this.quantity,
  });

  Product.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        alias = json['alias'],
        price = double.parse(json['price'].toString()),
        quantity = json['quantity'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['price'] = this.price;
    data['quantity'] = this.quantity;

    return data;
  }

  @override
  String toString() {
    return '${this.toJson()}';
  }
}
