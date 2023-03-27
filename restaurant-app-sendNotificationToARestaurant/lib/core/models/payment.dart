enum PaymentMethod { orangeMoney, cash, wallet, system }

class Payment {
  String? id;
  String? orderId;
  PaymentMethod? paymentMethod;
  int? amountPaid;
  DateTime? createdAt;
  DateTime? updatedAt;

  Payment({
    this.id,
    this.orderId,
    this.paymentMethod,
    this.amountPaid,
    this.createdAt,
    this.updatedAt,
  });

  Payment.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        orderId = json['orderId'],
        paymentMethod = json['paymentMethod'],
        amountPaid = json['amountPaid'],
        updatedAt = json['updatedAt'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['paymentMethod'] = this.paymentMethod;
    data['amountPaid'] = this.amountPaid;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
