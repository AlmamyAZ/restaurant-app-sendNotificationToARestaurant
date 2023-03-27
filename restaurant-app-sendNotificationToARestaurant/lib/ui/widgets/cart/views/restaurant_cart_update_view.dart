// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_options_view_model.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/menu_item_quantity_manager.dart';
import 'package:restaurant_app/ui/widgets/uielements/centered_scrollable_child.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';

class RestaurantCartUpdateView extends StatelessWidget {
  final RestaurantCartViewModel model;
  final Product element;
  const RestaurantCartUpdateView({
    required this.model,
    required this.element,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return ViewModelBuilder<RestaurantCartOptionsViewModel>.reactive(
        builder: (context, modelOptions, child) => Container(
            height: 280,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: FullFlatButton(
                  title: modelOptions.orderQuantity! > 0
                      ? 'Enregistrer'
                      : 'Supprimer',
                  color: modelOptions.orderQuantity! > 0
                      ? primaryColor
                      : Colors.red,
                  onPress: () {
                    model.updateCartElement(
                        element, modelOptions.orderQuantity!);
                    navigationService.back();
                  },
                  width: screenWidth(context),
                ),
              ),
              body: CenteredScrollableChild(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(element.alias!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Divider(),
                    MenuItemQuantityManager(
                      quantity: modelOptions.orderQuantity!,
                      onPress: modelOptions.handleItemQuantityChange,
                    ),
                    verticalSpaceSmall,
                    Text(
                        formatCurrency(
                            element.price! * modelOptions.orderQuantity!),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.grey)),
                  ],
                ),
              ),
            )),
        onModelReady: (modelOptions) {
          modelOptions.initialiseModelElement(model, element);
        },
        viewModelBuilder: () => locator<RestaurantCartOptionsViewModel>());
  }
}
