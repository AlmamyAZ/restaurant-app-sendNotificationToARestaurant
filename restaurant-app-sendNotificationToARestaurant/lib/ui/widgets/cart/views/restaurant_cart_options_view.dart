// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_options_view_model.dart';
import 'package:restaurant_app/ui/widgets/cart/view_models/restaurant_cart_view_model.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';

class RestaurantCartOptionsView extends StatelessWidget {
  final RestaurantCartViewModel model;
  final GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();

  RestaurantCartOptionsView({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return ViewModelBuilder<RestaurantCartOptionsViewModel>.reactive(
        createNewModelOnInsert: true,
        builder: (context, modelOptions, child) => AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 300),
            height: modelOptions.orderTime == OrderTime.asap ? 280 : 400,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: FullFlatButton(
                  title: 'Confirmer',
                  onPress: !(modelOptions.orderTime == OrderTime.later &&
                          (modelOptions.orderDay['label'] == null ||
                              modelOptions.orderHour!['label'] == null))
                      ? () {
                          model.setOrderDeliveryState(
                            modelOptions.orderIsDelivery,
                          );
                          model.setOrderTime(
                            modelOptions.orderTime,
                            modelOptions.orderHour!['label'],
                            modelOptions.orderDay['label'],
                          );
                          navigationService.back();
                        }
                      : null,
                  width: screenWidth(context),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalSpaceMedium,
                    RadioListTile<OrderTime>(
                      title: const Text(
                        'Dès que possible',
                        style: TextStyle(fontSize: 15),
                      ),
                      value: OrderTime.asap,
                      groupValue: modelOptions.orderTime,
                      activeColor: primaryColor,
                      onChanged: (OrderTime? value) {
                        modelOptions.setOrderTime(value!);
                      },
                    ),
                    RadioListTile<OrderTime>(
                      title: const Text(
                        'Programmer pour plus-tard',
                        style: TextStyle(fontSize: 15),
                      ),
                      value: OrderTime.later,
                      activeColor: primaryColor,
                      groupValue: modelOptions.orderTime,
                      onChanged: (OrderTime? value) {
                        modelOptions.setOrderTime(value!);
                      },
                    ),
                    if (modelOptions.orderTime == OrderTime.later)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 30),
                        child: Form(
                          key: _oFormKey,
                          child: Container(
                            width: screenWidth(context),
                            height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // SelectFormField(
                                //   //here ici le probleme
                                //   type: SelectFormFieldType.dropdown,
                                //   initialValue: modelOptions.orderDay['value'],
                                //   labelText: 'Jour',
                                //   style: TextStyle(
                                //       fontSize: 15,
                                //       fontWeight: FontWeight.w400),
                                //   items: modelOptions.days,
                                //   enabled: false,
                                //   onChanged: (val) {
                                //     modelOptions.setOrderDay(val);
                                //   },
                                // ),
                                Text(
                                  'Aujourd\'hui',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                verticalSpaceMedium,
                                if (!modelOptions.isBusy)
                                  modelOptions.generateTimeselector()
                                else
                                  CircularProgressIndicator(
                                    backgroundColor: primaryColorLight,
                                  )
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            )),
        onModelReady: (modelOptions) {
          modelOptions.getDeliveryHours();
          modelOptions.initialiseModel(model);
        },
        viewModelBuilder: () => locator<RestaurantCartOptionsViewModel>());
  }
}
