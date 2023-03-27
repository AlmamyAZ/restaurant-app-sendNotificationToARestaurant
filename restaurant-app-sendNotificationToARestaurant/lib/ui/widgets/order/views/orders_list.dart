import 'package:flutter/material.dart';
import 'package:restaurant_app/core/models/order.dart';
import 'package:restaurant_app/ui/widgets/order/skeletons/order_card_skeleton.dart';
import 'package:restaurant_app/ui/widgets/order/view_models/orders_view_model.dart';
import 'package:restaurant_app/ui/widgets/order/views/order_card.dart';
import 'package:restaurant_app/ui/widgets/uielements/empty_list.dart';
import 'package:stacked/stacked.dart';

class OrdersList extends ViewModelWidget<OrdersViewModel> {
  final bool completed;

  const OrdersList({required this.completed});

  @override
  Widget build(BuildContext context, OrdersViewModel ordersModel) {
    List<Order>? orders =
        completed ? ordersModel.ordersTerminated : ordersModel.ordersIncoming;
    return (!ordersModel.isBusy && orders.isEmpty)
        ? EmptyList(
            message: 'Rien à afficher pour le moment',
            sign: Icon(
              Icons.receipt_long_outlined,
              color: Colors.grey[400],
              size: 150,
            ),
          )
        : ListView.separated(
            itemBuilder: (context, idx) {
              Order order = ordersModel.busy(orders) ? Order() : orders[idx];
              return ordersModel.busy(orders)
                  ? OrderCardSkeleton()
                  : OrderCard(order: order);
            },
            separatorBuilder: (context, idx) => Divider(),
            itemCount: ordersModel.busy(orders) ? 5 : orders.length,
          );
  }
}
