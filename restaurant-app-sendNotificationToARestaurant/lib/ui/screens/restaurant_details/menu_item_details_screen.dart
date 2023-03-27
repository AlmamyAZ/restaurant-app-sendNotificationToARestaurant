// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/menu_item_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/menu_item_header.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/menu_item_presentation.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/menu_item_quantity_manager.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';

class MenuItemDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return ViewModelBuilder<MenuItemViewModel>.reactive(
      onModelReady: (model) {
        model.setMenuItemData(arguments['menuItem']);
        model.setMenuSectionId(arguments['menuSectionId']);
      },
      viewModelBuilder: () => MenuItemViewModel(),
      builder: (context, model, child) {
        return Scaffold(
            bottomNavigationBar: BottomAppBar(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: FullFlatButton(
                    title: 'Ajouter au panier',
                    onPress: () {
                      model.addMenuItemToCart(arguments['restaurantId']);
                    }),
              ),
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  actions: [
                    IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          model.share(arguments);
                        }),
                  ],
                  flexibleSpace:
                      MenuItemHeader(menuItem: arguments['menuItem'],menuSectionId: model.menuSectionId!, ),
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                  expandedHeight: 250,
                  elevation: 0,
                  pinned: true, toolbarTextStyle: TextTheme(
                    headline6: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ).bodyText2, titleTextStyle: TextTheme(
                    headline6: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ).headline6,
                ),
                SliverPadding(
                  padding: EdgeInsets.all(10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        MenuItemPresentation(menuItem: model.menuItem!),
                        Divider(),
                        verticalSpaceSmall,
                        MenuItemQuantityManager(
                          quantity: model.orderQuantity,
                          onPress: model.handleItemQuantityChange,
                        ),
                        verticalSpaceSmall,
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
