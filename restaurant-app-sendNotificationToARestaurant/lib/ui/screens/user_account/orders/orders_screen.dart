import 'package:flutter/material.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/widgets/order/view_models/orders_view_model.dart';
import 'package:restaurant_app/ui/widgets/order/views/orders_list.dart';
import 'package:stacked/stacked.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildChip(String text) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline6?.copyWith(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      );
    }

    return ViewModelBuilder<OrdersViewModel>.reactive(
      builder: (context, model, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Commandes',
                style: Theme.of(context).appBarTheme.toolbarTextStyle,
              ),
              bottom: TabBar(
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 4.0,
                indicatorPadding: EdgeInsets.all(0),
                tabs: [
                  Tab(
                    child: _buildChip('En cours'),
                  ),
                  Tab(
                    child: _buildChip('Traitée'),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                const OrdersList(completed: false),
                const OrdersList(completed: true),
              ],
            ),
          ),
        );
      },
      disposeViewModel: false,
      viewModelBuilder: () => locator<OrdersViewModel>(),
    );
  }
}
