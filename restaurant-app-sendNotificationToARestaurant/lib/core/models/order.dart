import 'package:restaurant_app/core/models/adress.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/core/models/payment.dart';

enum OrderStatus {
  waitingRestaurantConfirmation,
  processingByRestaurant,
  delivering,
  completed,
  rejectedByRestaurant,
  canceledByUser,
  waitingForPickup
}

class Order {
  String? id;
  String? waiterId;
  PaymentMethod? paymentMethod;
  List<Product>? products;
  OrderStatus? status;
  bool? completed;
  Adress? deliveryLocation;
  Adress? pickupLocation;
  double? total;
  double? subTotal;
  String? userId;
  String? restaurantId;
  String? restaurantName;
  String? orderDeliveryTime;
  String? orderDeliveryDay;
  String? orderNote;
  OrderTime? orderTime;
  bool? isDelivery;
  DateTime? createdAt;

  Order({
    this.id,
    this.waiterId,
    this.paymentMethod,
    this.products,
    this.status,
    this.completed,
    this.deliveryLocation,
    this.pickupLocation,
    this.total,
    this.userId,
    this.restaurantId,
    this.restaurantName,
    this.orderDeliveryTime,
    this.orderDeliveryDay,
    this.orderNote,
    this.orderTime,
    this.isDelivery,
    this.createdAt,
  });

  Order.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        waiterId = json['waiterId'],
        paymentMethod = json['paymentMethodIndex'],
        products = [
          for (var product in json['products'])
            Product.fromJson(product, product['id'])
        ],
        status = json['status'],
        completed = json['completed'],
        deliveryLocation = json['deliveryLocation'],
        pickupLocation = json['pickupLocation'],
        total = double.parse(json['total'].toString()),
        subTotal = double.parse(json['subTotal'].toString()),
        userId = json['userId'],
        restaurantId = json['restaurantId'],
        restaurantName = json['restaurantName'],
        orderDeliveryTime = json['orderDeliveryTime'],
        orderDeliveryDay = json['orderDeliveryDay'],
        orderNote = json['orderNote'],
        orderTime = json['orderTime'],
        isDelivery = json['isDelivery'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentMethodIndex'] = this.paymentMethod!.index;
    data['products'] = this.products;
    data['status'] = this.status.toString();
    data['completed'] = this.completed;
    data['deliveryLocation'] = this.deliveryLocation;
    data['pickupLocation'] = this.pickupLocation;
    data['total'] = this.total;
    data['subTotal'] = this.subTotal;
    data['userId'] = this.userId;
    data['waiterId'] = this.waiterId;
    data['restaurantId'] = this.restaurantId;
    data['restaurantName'] = this.restaurantName;
    data['orderDeliveryTime'] = this.orderDeliveryTime;
    data['orderDeliveryDay'] = this.orderDeliveryDay;
    data['orderNote'] = this.orderNote;
    data['orderTime'] = this.orderTime.toString();
    data['isDelivery'] = this.isDelivery;
    data['createdAt'] = this.createdAt;
    return data;
  }

  static Order serializeOrder(Map<String, dynamic> data, String id) {
    data['createdAt'] = data['createdAt'].toDate();
    data['deliveryLocation'] = Adress.serializeAdress(data['deliveryLocation']);
    data['pickupLocation'] = Adress.serializeAdress(data['pickupLocation']);
    data['status'] = OrderStatus.values[data['status']];
    data['orderTime'] = OrderTime.values[data['orderTime']];
    data['paymentMethodIndex'] =
        PaymentMethod.values[data['paymentMethodIndex']];
    var order = Order.fromJson(data, id);
    return order;
  }
}
