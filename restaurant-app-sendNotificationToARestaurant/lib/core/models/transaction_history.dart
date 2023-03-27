// ignore_for_file: public_member_api_docs, sort_constructors_first
class TransactionHistory {
  String id;
  String transactionNumber;
  double amount;
  DateTime createdAt;
  String name;
  bool isEntry;
  TransactionHistory({
    required this.id,
    required this.transactionNumber,
    required this.amount,
    required this.createdAt,
    required this.name,
    required this.isEntry,
  });
  TransactionHistory.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        transactionNumber = id.substring(id.length - 6),
        amount = json['amount'],
        createdAt = json['createdAt'],
        name = json['name'],
        isEntry = json['isEntry'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionNumber'] = this.transactionNumber;
    data['amount'] = this.amount;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
