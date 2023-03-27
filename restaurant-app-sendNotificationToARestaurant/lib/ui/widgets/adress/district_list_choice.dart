import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_adresses/adresses_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class DistrictListChoices extends StatelessWidget {
  final AdressesViewModel model;

  DistrictListChoices({required this.model});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: screenHeight(context) / 2,
      curve: Curves.bounceIn,
      duration: Duration(milliseconds: 300),
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: model.districts.length,
        itemBuilder: (ctx, idx) {
          return ListTile(
              leading: Icon(
                Icons.location_city_outlined,
                color: primaryColor,
              ),
              title: Text(
                model.districts[idx],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                model.districtController.text == model.districts[idx]
                    ? Icons.radio_button_on
                    : Icons.radio_button_off,
                size: 15,
                color: primaryColor,
              ),
              onTap: () async {
                model.selectDistrict(model.districts[idx]);
              });
        },
      ),
    );
  }
}
