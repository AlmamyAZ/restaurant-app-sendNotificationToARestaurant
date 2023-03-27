import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/payment.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_adresses/adresses_view_model.dart';
import 'package:restaurant_app/ui/setup_snackbar_ui.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_checkout_view_model.dart';
import 'package:restaurant_app/ui/widgets/cart/views/order_schedule.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';
import 'package:stacked/stacked.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_view_model.dart';

class CartCheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cartModel = ModalRoute.of(context)?.settings.arguments;
    return ViewModelBuilder<RestaurantCartCheckoutViewModel>.reactive(
        viewModelBuilder: () => locator<RestaurantCartCheckoutViewModel>(),
        onModelReady: (model) async {
          model.getUserWallet();
          await model.setRestaurant();
          model.calculateDeliveryFees();
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Commande',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Text(
                    restaurantService.currentRestaurantName!,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.22,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  children: [
                    model.restaurantCart!.isDelivery!
                        ? buildRowDetailPrice(
                            'Frais de livraison',
                            model.deliveryFees,
                          )
                        : Container(),
                    buildRowDetailPrice('Frais de service', 2000),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Total a payer',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          horizontalSpaceLarge,
                          horizontalSpaceTiny,
                          Text(
                            model.restaurantCart?.total != null
                                ? formatCurrency(
                                    model.restaurantCart!.total! +
                                        model.deliveryFees +
                                        2000,
                                  )
                                : '',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ]),
                    verticalSpaceSmall,
                    FullFlatButton(
                      title: 'Valider la commande',
                      onPress: (model.paymentMethod == null ||
                              (model.orderAdress == null &&
                                  model.restaurantCart!.isDelivery!))
                          ? () => {
                                snackbarService.showCustomSnackBar(
                                  duration: const Duration(seconds: 5),
                                  variant: SnackbarType.warning,
                                  title: "Faites un choix",
                                  message:
                                      "Veuillez choisir une methode de paiement et une adresse de livraison",
                                )
                              }
                          : () {
                              model.processOrder(context);
                            },
                      width: screenWidth(context),
                    ),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderSchedule(
                      model: cartModel as RestaurantCartViewModel,
                      readOnly: true,
                    ),
                    Divider(),
                    Container(
                        child: model.busy(model.restaurant)
                            ? null
                            : OrderAdress(
                                checkoutModel: model,
                                sectionTitle: 'Adresse de livraison',
                                buttonTitle: 'Ajouter une Adresse',
                                buttonIcon: Icons.add_location_alt_outlined,
                              )),
                    Divider(),
                    PaymentMethods()
                  ],
                ),
              ),
            ),
          );
        });
  }
}

//widget à exporter
Widget buildRowDetailPrice(String title, double amount) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        title,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey[600]),
      ),
      Text(
        formatCurrency(amount),
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey[600]),
      ),
    ]),
  );
}

class PaymentMethods extends ViewModelWidget<RestaurantCartCheckoutViewModel> {
  const PaymentMethods({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, RestaurantCartCheckoutViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Methode de paiement',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          verticalSpaceSmall,
          ListTile(
            onTap: () {
              model.handlePaymentMethodChange(PaymentMethod.orangeMoney);
            },
            leading: SizedBox(
              width: 30,
              child: Image.asset(
                'assets/images/logo_icons/OM.png',
              ),
            ),
            title: Text('Orange Money'),
            trailing: Icon(
              model.paymentMethod == PaymentMethod.orangeMoney
                  ? Icons.radio_button_on
                  : Icons.radio_button_off,
              size: 20,
              color: primaryColor,
            ),
          ),
          verticalSpaceTiny,
          ListTile(
            onTap: () {
              model.handlePaymentMethodChange(PaymentMethod.cash);
            },
            leading: SizedBox(
              width: 30,
              child: Image.asset(
                'assets/images/logo_icons/MM.png',
              ),
            ),
            title: Text('Cash'),
            trailing: Icon(
              model.paymentMethod == PaymentMethod.cash
                  ? Icons.radio_button_on
                  : Icons.radio_button_off,
              size: 20,
              color: primaryColor,
            ),
          ),
          verticalSpaceTiny,
          ListTile(
              onTap: () {
                model.handlePaymentMethodChange(PaymentMethod.wallet);
              },
              leading: SizedBox(
                width: 30,
                child: Image.asset(
                  'assets/images/logo_icons/wallet-logo.png',
                ),
              ),
              title: Text('Wallet'),
              trailing: Icon(
                model.paymentMethod == PaymentMethod.wallet
                    ? Icons.radio_button_on
                    : Icons.radio_button_off,
                size: 20,
                color: primaryColor,
              ),
              subtitle: Text(
                "${formatCurrency(model.walletAccount.balance)}",
                style: TextStyle(fontSize: 15),
              )),
        ],
      ),
    );
  }
}

class OrderAdress extends StatelessWidget {
  final RestaurantCartCheckoutViewModel checkoutModel;
  final String? sectionTitle;
  final Function? onPress;
  final String? buttonTitle;
  final IconData? buttonIcon;

  const OrderAdress({
    required this.checkoutModel,
    this.sectionTitle,
    this.onPress,
    this.buttonTitle,
    this.buttonIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AdressesViewModel>.reactive(
      onModelReady: (model) async {
        await model.fetchFirstAdress();
        if (model.selectedAdress == null) return;
        checkoutModel.setOrderAdressToCheckout(model.selectedAdress!);
        model.initialiseMapForm(initialisationData: {
          'adress': model.selectedAdress,
          'newAdress': false,
          'coordinates': model.selectedAdress!.latLng
        }, model: checkoutModel);
      },
      viewModelBuilder: () => locator<AdressesViewModel>(),
      builder: (context, model, child) => !checkoutModel
              .restaurantCart!.isDelivery!
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sectionTitle!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (!model.isBusy && model.selectedAdress != null)
                    MapPreview(model: model),
                  if (model.isBusy)
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(50),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  verticalSpaceSmall,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FullFlatButton(
                          icon: FaIcon(
                            buttonIcon,
                            color: primaryColor,
                          ),
                          title: (!model.isBusy && model.selectedAdress != null)
                              ? 'Changer l\'adresse'
                              : buttonTitle!,
                          color: Colors.white,
                          textColor: primaryColor,
                          onPress: () async {
                            if (!model.isBusy && model.selectedAdress != null) {
                              model.showAdresses(context, model);
                            } else {
                              await model.addNewAdress();
                              await model.fetchFirstAdress();
                              checkoutModel.setOrderAdressToCheckout(
                                  model.selectedAdress!);
                              await model.initialiseMapForm(
                                initialisationData: {
                                  'adress': model.selectedAdress,
                                  'newAdress': false,
                                  'coordinates': model.selectedAdress!.latLng
                                },
                              );
                            }
                          },
                        ),
                      ]),
                ],
              ),
            ),
    );
  }
}

class MapPreview extends StatelessWidget {
  final AdressesViewModel? model;
  const MapPreview({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpaceSmall,
        Container(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: GoogleMap(
              mapType: MapType.normal,
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              zoomControlsEnabled: false,

              // markers:
              markers: model!.markers,
              initialCameraPosition: CameraPosition(
                target: model!.initialPosition,
                zoom: 15,
              ),
              onMapCreated: model!.onMapCreated,
            ),
          ),
        ),
        verticalSpaceSmall,
        ListTile(
          leading: Icon(
            Icons.location_on_outlined,
            color: primaryColor,
          ),
          title: Text(
            model!.selectedAdress!.name!,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model!.selectedAdress!.zone}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                '${model!.selectedAdress!.district}, Conakry',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
