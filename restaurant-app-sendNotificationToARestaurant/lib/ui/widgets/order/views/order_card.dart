import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/models/order.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/order/view_models/orders_view_model.dart';
import 'package:stacked/stacked.dart';

class OrderCard extends ViewModelWidget<OrdersViewModel> {
  const OrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context, OrdersViewModel ordersModel) {
    return InkWell(
      key: ValueKey(key),
      onTap: () {
        ordersModel.navigateToOrderDetails(
            completed: order.completed!, order: order);
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                dense: true,
                leading: Icon(Icons.receipt, color: primaryColor),
                trailing: TextButton(
                  onPressed: () {
                    ordersModel.navigateToOrderDetails(
                        completed: order.completed!, order: order);
                  },
                  child: Text(
                    'VOIR LES DETAILS',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: primaryColor),
                  ),
                ),
                minLeadingWidth: 0,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                title: SizedBox(
                  width: screenWidth(context) / 1.5,
                  child: Text(order.restaurantName!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black)),
                ),
                subtitle: Text(order.isDelivery! ? 'Livraison' : 'A recuperer',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                decoration: BoxDecoration(
                    color: formatOrderStatus(order.status!)!['color']
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  '${formatOrderStatus(order.status!)!['label']}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: formatOrderStatus(order.status!)!['color']),
                ),
              ),
              verticalSpaceTiny,
              Text(
                'COMMANDE No - ${order.id}',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey[500]),
              ),
              verticalSpaceTiny,
              Text(
                '${DateFormat.yMMMd('fr_FR').format(order.createdAt!)} à ${DateFormat.Hm().format(order.createdAt!)}',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.grey[500]),
              ),
              verticalSpaceTiny,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black)),
                  Text('${formatCurrency(order.total!)}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black)),
                ],
              )
            ],
          )),
    );
  }
}
