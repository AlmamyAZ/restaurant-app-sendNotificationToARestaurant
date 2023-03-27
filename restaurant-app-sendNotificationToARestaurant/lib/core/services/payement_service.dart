import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PayementService {
  Future verifyOmPayement(token, payToken, orderId, amount) async {
    print('verification started');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.orange.com/orange-money-webpay/dev/v1/transactionstatus'));

    request.body = json
        .encode({"order_id": orderId, "amount": amount, "pay_token": payToken});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('response ok ');
      var body = await response.stream.bytesToString();
      Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(body));
      return data["status"];
    } else {
      print(response.reasonPhrase);
      throw Exception("une erreur s'est produite veuillez réessayer ");
    }
  }

  Future getOMToken() async {
    String authorization = dotenv.env['AUTHORIZATION'] ?? 'not found';
    var headers = {
      'Authorization': 'Basic $authorization',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    var request = http.Request(
        'POST', Uri.parse('https://api.orange.com/oauth/v3/token'));
    request.bodyFields = {'grant_type': 'client_credentials'};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();

      print(body);
      Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(body));
      return data['access_token'];
    } else {
      print(response.reasonPhrase);

      throw Exception("une erreur s'est produite veuillez réessayer ");
    }
  }

  Future payOrder(String orderId, String token, double amount) async {
    String merchantKey = dotenv.env['MERCHANT_KEY']!;
    String returnUrl = dotenv.env['RETURN_URL']!;
    String cancelUrl = dotenv.env['CANCEL_URL']!;
    String notifUrl = dotenv.env['NOTIFY_URL']!;

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    };

    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.orange.com/orange-money-webpay/dev/v1/webpayment'));

    request.body = json.encode({
      "merchant_key": merchantKey,
      "currency": "OUV",
      "order_id": orderId,
      "amount": amount,
      "return_url": returnUrl,
      "cancel_url": cancelUrl,
      "notif_url": notifUrl,
      "lang": "fr",
      "reference": "MadiFood"
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('response ok ');
      var body = await response.stream.bytesToString();
      Map<String, dynamic> data = Map<String, dynamic>.from(jsonDecode(body));
      String paymentUrl = data['payment_url'];
      String payToken = data['pay_token'];
      return {'paymentUrl': paymentUrl, 'payToken': payToken};
    } else {
      print(response.reasonPhrase);
      throw Exception("une erreur s'est produite veuillez réessayer ");
    }
  }

  Future payWithOM(String orderId, double amount) async {
    try {
      var token = await getOMToken();
      var result = await payOrder(orderId, token, amount);
      String url = result['paymentUrl'];
      String payToken = result['payToken'];
      return {'url': url, 'payToken': payToken, 'token': token};
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
        return e.message;
      }
      print(e.toString());
      return e.toString();
    }
  }
}
