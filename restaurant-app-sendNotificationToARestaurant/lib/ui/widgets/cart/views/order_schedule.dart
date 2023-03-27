import 'package:flutter/material.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_view_model.dart';

class OrderSchedule extends StatelessWidget {
  final RestaurantCartViewModel model;
  final bool readOnly;

  const OrderSchedule({Key? key, required this.model, this.readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: readOnly
          ? null
          : () {
              model.showOrderOptions(context, model);
            },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColorLight,
          child: Icon(
            model.restaurantCart!.isDelivery!
                ? Icons.delivery_dining
                : Icons.shopping_bag_rounded,
            color: primaryColor,
          ),
        ),
        title: Text(
            model.restaurantCart!.isDelivery!
                ? (model.restaurantCart!.orderTime == OrderTime.asap
                    ? 'Livrer dans 20 - 35 min'
                    : 'Livrer ${model.restaurantCart?.orderDeliveryDay} entre ${model.restaurantCart?.orderDeliveryTime}')
                : (model.restaurantCart!.orderTime == OrderTime.asap
                    ? 'Près dans 20 - 35 min'
                    : 'Près ${model.restaurantCart?.orderDeliveryDay} entre ${model.restaurantCart?.orderDeliveryTime}'),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            )),
        trailing: readOnly
            ? null
            : Text('Changer',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                )),
      ),
    );
  }
}
