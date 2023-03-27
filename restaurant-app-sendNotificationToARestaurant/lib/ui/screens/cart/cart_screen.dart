import 'package:flutter/material.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/ui/widgets/uielements/primary_chip.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_view_model.dart';
import 'package:restaurant_app/ui/widgets/cart/views/order_schedule.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/text_link.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantCartViewModel>.reactive(
        viewModelBuilder: () => locator<RestaurantCartViewModel>(),
        onModelReady: (model) {},
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mon Panier',
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
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    model.removeCart();
                  },
                )
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              child: Container(
                height: 110,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Montant total',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            model.restaurantCart?.total != null
                                ? formatCurrency(model.restaurantCart!.total!)
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
                      title: 'Placer la Commande',
                      onPress: () async {
                        //verifier if is open
                        if (authenticationService.currentUser == null) {
                          await navigationService.navigateTo(Routes.loginView);
                          if (firebaseAuth.currentUser == null) return;
                        }
                        model.isROpen()
                            ? model.navigateToCheckout()
                            : snackbarService.showSnackbar(
                                title: 'Restaurant Fermé',
                                message:
                                    'Le restaurant est fermé pour le moment',
                              );
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
                  verticalSpaceMedium,
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryChip(
                          isActive: model.restaurantCart?.isDelivery as bool,
                          label: 'Livraison',
                          onPress: () {
                            model.setOrderDeliveryState(true);
                          },
                        ),
                        PrimaryChip(
                          isActive: !model.restaurantCart!.isDelivery!,
                          label: 'A recuperer',
                          onPress: () {
                            model.setOrderDeliveryState(false);
                          },
                        )
                      ]),
                  OrderSchedule(model: model),
                  Divider(),
                  InkWell(
                    onTap: () {
                      model.navigateToOrderNoteScreen(model);
                    },
                    child: SizedBox(
                      width: screenWidth(context),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextLink(
                              'Ajouter une precision',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: primaryColor,
                              ),
                            ),
                            if (model.restaurantCart?.orderNote != null &&
                                model.restaurantCart?.orderNote != '')
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  model.restaurantCart!.orderNote!,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      'Elements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Divider(),
                  ...model.restaurantCart!.products!
                      .map((e) => buildListTile(e, context, model))
                      .toList(),
                ],
              )),
            ),
          );
        });
  }

  // Widget buildRowDetailPrice(String title, double amount) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
  //     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //       Text(
  //         title,
  //         style: TextStyle(
  //             fontSize: 15,
  //             fontWeight: FontWeight.w400,
  //             color: Colors.grey[600]),
  //       ),
  //       Text(
  //         formatCurrency(amount),
  //         style: TextStyle(
  //             fontSize: 15,
  //             fontWeight: FontWeight.w400,
  //             color: Colors.grey[600]),
  //       ),
  //     ]),
  //   );
  // }

  Widget buildListTile(
    Product e,
    BuildContext context,
    dynamic model,
  ) {
    return InkWell(
      onTap: () {
        model.showUpdateElement(context, model, e);
      },
      child: ListTile(
        horizontalTitleGap: 0,
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        leading: Text(
          '${e.quantity} x',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: primaryColor),
        ),
        title: Text(
          '${e.alias}',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        trailing: Text(
          formatCurrency(e.quantity! * e.price!),
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
