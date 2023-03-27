// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/adress.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_adresses/adresses_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';

class AdressesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AdressesViewModel>.reactive(
      viewModelBuilder: () => locator<AdressesViewModel>(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Mes Adresses',
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.add_location_alt),
                onPressed: () async {
                  var backResult = await navigationService
                      .navigateTo(Routes.adressMapSelectionScreen);

                  if (backResult['active']) {
                    model.onBackAdressMessage(backResult['message']);
                  }
                })
          ],
        ),
        body: model.dataReady && model.adresses?.length == 0
            ? EmptyAdressesList()
            : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: !model.dataReady ? 10 : model.adresses?.length,
                itemBuilder: (ctx, idx) {
                  Adress adress =
                      !model.dataReady ? Adress() : model.adresses![idx]!;
                  return !model.dataReady
                      ? AdressSkeletonCard()
                      : ListTile(
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: primaryColor,
                          ),
                          title: Text(
                            adress.name!,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                adress.zone!,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                adress.district!,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Colors.grey,
                          ),
                          onTap: () async {
                            var backResult = await navigationService.navigateTo(
                                Routes.adressFormScreen,
                                arguments: {
                                  'newAdress': false,
                                  'adress': adress,
                                  'coordinates': adress.latLng
                                });
                            if (backResult == null) return;
                            if (backResult['active']) {
                              model.onBackAdressMessage(backResult['message']);
                            }
                          },
                        );
                },
              ),
      ),
    );
  }
}

class AdressSkeletonCard extends StatelessWidget {
  const AdressSkeletonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentPlaceholder(
      spacing: EdgeInsets.all(10),
      height: double.infinity,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        // height: 100,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentPlaceholder.block(
                  width: MediaQuery.of(context).size.width * 0.6, height: 10),
              ContentPlaceholder.block(
                  width: MediaQuery.of(context).size.width * 0.3, height: 7),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyAdressesList extends ViewModelWidget<AdressesViewModel> {
  const EmptyAdressesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, AdressesViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FullFlatButton(
            icon: FaIcon(
              Icons.add_location_alt_outlined,
              color: primaryColor,
            ),
            title: 'Ajouter une Adresse',
            color: Colors.white,
            textColor: primaryColor,
            onPress: () async {
              var backResult = await navigationService
                  .navigateTo(Routes.adressMapSelectionScreen);

              if (backResult['active']) {
                model.onBackAdressMessage(backResult['message']);
              }
            },
          )
        ],
      ),
    );
  }
}
