class WalletAccount {
  String id;
  double balance;
  DateTime? lastRechargeDate;
  WalletAccount({
    required this.id,
    required this.balance,
    required this.lastRechargeDate,
  });
  WalletAccount.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        balance = json['balance'].toDouble(),
        lastRechargeDate = json['lastRechargeDate'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['lastRechargeDate'] = this.lastRechargeDate;
    return data;
  }
}
