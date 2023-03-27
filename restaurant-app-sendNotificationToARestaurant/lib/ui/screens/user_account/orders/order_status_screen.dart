import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/core/models/order.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/order/view_models/order_details_view_model.dart';
import 'package:restaurant_app/ui/widgets/uielements/text_link.dart';
import 'package:stacked/stacked.dart';

class OrderStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //get arguments from previous screen
    final String orderId = ModalRoute.of(context)!.settings.arguments as String;

    return ViewModelBuilder<OrderDetailsViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status commande',
                  style: Theme.of(context).appBarTheme.toolbarTextStyle,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  model.dataReady && !model.isBusy
                      ? MapPreview(model: model)
                      : Center(child: CircularProgressIndicator()),
                  verticalSpaceMedium,
                ],
              ),
            ),
          ),
        );
      },
      onModelReady: (model) async {
        model.initialiseViewModel(orderId);
        // model.initialiseMap();
        // await model.updateCameraLocation(
        //     model.pickupLocation, model.deliveryLocation, model.mapController);
      },
      viewModelBuilder: () => locator<OrderDetailsViewModel>(),
    );
  }
}

class MapPreview extends StatelessWidget {
  final OrderDetailsViewModel model;
  const MapPreview({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          child: Stack(children: [
            GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,

              // markers:
              markers: model.markers,
              initialCameraPosition: CameraPosition(
                target: model.initialPosition,
                zoom: 11,
              ),
              onMapCreated: model.onMapCreated,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.vertical(
                        top: Radius.circular(5))),
              ),
            )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                decoration: BoxDecoration(
                    color: formatOrderStatus(
                        model.selectedOrder!.status!)!['color'],
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  '${formatOrderStatus(model.selectedOrder!.status!)!['label']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ),
              verticalSpaceSmall,
              Text(
                'Estimation de la livraison',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryColor),
              ),
              Text(
                model.selectedOrder?.status ==
                        OrderStatus.waitingRestaurantConfirmation
                    ? 'Indisponible'
                    : model.selectedOrder!.orderDeliveryTime ?? 'Indisponible',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              verticalSpaceSmall,
              Text(model.getOrderEstimateDelivery()),
              verticalSpaceTiny,
              if (model.selectedOrder!.status! ==
                  OrderStatus.waitingRestaurantConfirmation)
                model.busy(model.selectedOrder)
                    ? Text('...')
                    : TextLink(
                        'Annuler',
                        onPressed: () async {
                          model.cancelOrder();
                        },
                        style: TextStyle(color: Colors.red),
                      ),
              verticalSpaceMedium,
              Text(
                'Recapitulatif de la commande',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryColor),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(Icons.restaurant),
                dense: true,
                minLeadingWidth: 0,
                title: Text(
                  '${model.selectedOrder?.restaurantName}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text('COMMANDE No - ${model.selectedOrder?.id}'),
              ),
              Text(
                'Precision : ${model.selectedOrder?.orderNote}',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
              Divider(),
              ...model.selectedOrder!.products!
                  .map((e) => buildListTile(e, context, model))
                  .toList(),
              Divider(),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        model.navigateToOrderDetails();
                      },
                      child: Text(
                        'Voir les Details',
                        style: TextStyle(color: primaryColor),
                      )),
                  Spacer(),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Besoin d\'aide',
                        style: TextStyle(color: primaryColor),
                      ))
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildListTile(
    Product e,
    BuildContext context,
    dynamic model,
  ) {
    return ListTile(
      horizontalTitleGap: 0,
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      leading: Text(
        '${e.quantity} x',
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[500]),
      ),
      title: Text(
        '${e.alias}',
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[500]),
      ),
      trailing: Text(
        formatCurrency(e.quantity! * e.price!),
        style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey[500]),
      ),
    );
  }
}
