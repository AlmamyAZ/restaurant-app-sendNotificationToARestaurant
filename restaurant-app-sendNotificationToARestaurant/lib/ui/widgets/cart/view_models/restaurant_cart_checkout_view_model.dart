import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/adress.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/core/models/order.dart' as OrderModel;
import 'package:restaurant_app/core/models/payment.dart';
import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/core/models/wallet_account.dart';
import 'package:restaurant_app/core/services/payement_service.dart';
import 'package:restaurant_app/ui/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

@injectable
class RestaurantCartCheckoutViewModel extends ReactiveViewModel {
  PayementService payementService = locator<PayementService>();

  bool _isVerifying = false;
  bool get isVerifying => _isVerifying;

  Restaurant? restaurant;
  String? _currentRestaurantWaiterId;
  String? get currentRestaurantWaiterId => _currentRestaurantWaiterId;

  void setCurrentRestaurantWaiterId(String? id) {
    _currentRestaurantWaiterId = id;
  }

  WalletAccount _walletAccount = WalletAccount(
    balance: 0,
    id: '',
    lastRechargeDate: DateTime.now(),
  );

  WalletAccount get walletAccount => _walletAccount;

  Cart? get restaurantCart =>
      cartService.getCartByRestaurantId(restaurantService.currentRestaurantId!);
  double _deliveryFees = 0;
  double get deliveryFees => _deliveryFees;
  PaymentMethod? _paymentMethod;
  PaymentMethod? get paymentMethod => _paymentMethod;
  Adress? _orderAdress;
  Adress? get orderAdress => _orderAdress;

  Future getUserWallet() async {
    setBusy(true);
    _walletAccount = await walletAccountService.getUserWallet();
    setBusy(false);
    notifyListeners();
  }

  Future setRestaurant() async {
    setBusyForObject(restaurant, true);
    restaurant = await restaurantService
        .getRestaurantById('${restaurantCart!.restaurantId}');
    setBusyForObject(restaurant, false);
    notifyListeners();
  }

  void calculateDeliveryFees() {
    if (orderAdress == null) {
      return;
    }
    setBusy(true);
    if (restaurantCart!.isDelivery!) {
      double distance = mapService.getDistanceBeetweenTwoLocation(
        restaurant!.position!,
        orderAdress!.latLng!,
      );
      // calculate delivery fees per kilometer
      if (distance > 0 && distance <= 6) {
        _deliveryFees = restaurantCart!.isDelivery! ? 5000 : 0;
      } else if (distance > 6 && distance <= 12) {
        _deliveryFees = restaurantCart!.isDelivery! ? 10000 : 0;
      } else if (distance > 12 && distance <= 24) {
        _deliveryFees = restaurantCart!.isDelivery! ? 15000 : 0;
      } else if (distance > 24 && distance <= 36) {
        _deliveryFees = restaurantCart!.isDelivery! ? 20000 : 0;
      } else {
        _deliveryFees = restaurantCart!.isDelivery! ? 1000000 : 0;
      }
    }
    setBusy(false);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [cartService];

  void setOrderAdressToCheckout(Adress adress) {
    _orderAdress = adress;
    calculateDeliveryFees();
    notifyListeners();
  }

  void handlePaymentMethodChange(PaymentMethod value) {
    _paymentMethod = value;
    notifyListeners();
  }

  void showDialogV(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Vérification du paiement...'),
            content: Container(
              height: 100,
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Veuillez patienter pendant la vérification...'),
                  ],
                ),
              ),
            ),
          );
        });
  }

  double getTotalPrice() {
    return restaurantCart!.total! + deliveryFees + 2000.0;
  }

  void showFeedBack({bool isSuccess = true, String? message}) {
    // show toast
    snackbarService.showCustomSnackBar(
      duration: const Duration(seconds: 5),
      variant: isSuccess ? SnackbarType.success : SnackbarType.error,
      title: isSuccess ? 'Paiement réussi' : 'Paiement échoué',
      message: message == null
          ? isSuccess
              ? 'Votre paiement a été effectué'
              : 'Echec du paiement vueillez réessayer'
          : message,
    );
  }

  Future processOrderWithOM(context, orderId) async {
    var result = await payementService.payWithOM(orderId, getTotalPrice());
    String url = result['url'];
    String token = result['token'];
    String payToken = result['payToken'];
    await navigationService.navigateTo(Routes.omPaymentScreenView,
        arguments: url);
    showDialogV(context);
    String resultV = await payementService.verifyOmPayement(
      token,
      payToken,
      orderId,
      getTotalPrice(),
    );

    if (resultV != 'SUCCESS') throw Exception('Paiement échoué');
    showFeedBack(isSuccess: true);

    return {
      'token': token,
      'payToken': payToken,
    };
  }
// create a function that fetch data from firestore using flutter
  Future processOrderWithWallet(context, orderId) async {
    showDialogV(context);
    await walletAccountService.payWithWallet(
      getTotalPrice(),
    );
    navigationService.back();
    showFeedBack(isSuccess: true);
  }

  Future processOrder(context) async {
    try {
      String orderId = "ORDER_${Uuid().v4()}";

      Map<String, dynamic> order;
      Map<String, dynamic> paymentData = {};

      if (paymentMethod == PaymentMethod.orangeMoney) {
        var result = await processOrderWithOM(context, orderId);
        String token = result['token'];
        String payToken = result['payToken'];
        paymentData =
            getPayementData(orderId: orderId, payToken: payToken, token: token);
      } else if (paymentMethod == PaymentMethod.cash) {
        paymentData = getPayementData(orderId: orderId);
      } else if (paymentMethod == PaymentMethod.wallet) {
        await processOrderWithWallet(context, orderId);
        paymentData = getPayementData(orderId: orderId);
      }

      order = getOrderData();
      cartService.removeCartToRestaurantCarts(restaurantCart!.restaurantId!);
      await orderService.addUserOrder(order, orderId, paymentData);
      navigationService.popRepeated(2);
      navigationService.navigateTo(Routes.ordersScreen);
      navigationService.navigateTo(Routes.orderStatusScreen,
          arguments: orderId);
    } on Exception catch (error) {
      navigationService.back();
      showFeedBack(isSuccess: false, message: error.toString());
      print('🥱🥱🥱🥱🥱 $error');
    } catch (error) {
      showFeedBack(isSuccess: false, message: error.toString());
      print('🥱🥱🥱🥱🥱 $error');
    }
  }

  Map<String, dynamic> getPayementData({required orderId, payToken, token}) {
    Map<String, dynamic> payement = {
      'amount': getTotalPrice(),
      'currency': 'gnf',
      'orderId': 'ORDER_${Uuid().v4()}',
      'nature': 'order',
      'type': 'input',
      'reference': payToken == null ? '' : payToken,
      'token': token == null ? '' : token,
      'status': 'success',
      'payToken': payToken == null ? '' : payToken,
      'paymentMethod': _paymentMethod!.index,
      'restaurantId': restaurantCart!.restaurantId,
      'userId': restaurantCart!.userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
    return payement;
  }

  Adress restaurantInfoToAdress(Restaurant restaurant) {
    return Adress(
      latLng: mapService.convertGeoFireToCoordinates(
        restaurant.position!,
      ),
      name: restaurant.name,
      contactNumber: restaurant.phoneNumber,
      description: " ${restaurant.adress}",
    );
  }

  Map<String, dynamic> getOrderData() {
    Map<String, dynamic> order = {
      'completed': false,
      'isDelivery': restaurantCart?.isDelivery,
      'deliveryLocation': restaurantCart!.isDelivery!
          ? convertAdressToJson(_orderAdress!)
          : null,
      'orderDeliveryTime': restaurantCart?.orderDeliveryTime,
      'orderDeliveryDay': restaurantCart?.orderDeliveryDay,
      'orderTime': restaurantCart?.orderTime!.index,
      'paymentMethodIndex': _paymentMethod?.index,
      'restaurantId': restaurantCart?.restaurantId,
      'restaurantName': restaurantService.currentRestaurantName,
      'restaurantPhoneNumber': restaurantService.currentRestaurantPhoneNumber,
      'userId': restaurantCart?.userId,
      'waiterId': restaurant?.waiterId,
      'userName': authenticationService.currentUser?.username,
      'status': OrderModel.OrderStatus.waitingRestaurantConfirmation.index,
      'deliveryFees': _deliveryFees,
      'serviceFees': 2000.0,
      'subTotal': restaurantCart!.total!,
      'total': getTotalPrice(),
      'pickupLocation':
          convertAdressToJson(restaurantInfoToAdress(restaurant!)),
      'orderNote': restaurantCart?.orderNote,
      'products':
          restaurantCart?.products?.map((product) => product.toJson()).toList(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp()
    };
    return order;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
