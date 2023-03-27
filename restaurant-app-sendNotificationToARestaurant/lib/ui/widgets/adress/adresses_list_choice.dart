import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/adress.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_adresses/adresses_list_screen.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_adresses/adresses_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';

class AdressesListChoices extends StatefulWidget {
  final AdressesViewModel? model;

  AdressesListChoices({this.model});

  @override
  _AdressesListChoicesState createState() => _AdressesListChoicesState();
}

class _AdressesListChoicesState extends State<AdressesListChoices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: FullFlatButton(
          icon: FaIcon(
            Icons.add_location_alt_outlined,
            color: primaryColor,
          ),
          title: 'Ajouter une adresse',
          color: Colors.white,
          textColor: primaryColor,
          onPress: () async {
            await widget.model!.addNewAdress();
          },
        ),
      ),
      body: widget.model!.dataReady && widget.model!.adresses?.length == 0
          ? EmptyAdressesList()
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: !widget.model!.dataReady
                  ? 10
                  : widget.model!.adresses?.length,
              itemBuilder: (ctx, idx) {
                Adress adress = !widget.model!.dataReady
                    ? Adress()
                    : widget.model!.adresses![idx]!;
                return !widget.model!.dataReady
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
                          widget.model!.selectedAdress?.id == adress.id
                              ? Icons.radio_button_on
                              : Icons.radio_button_off,
                          size: 15,
                          color: primaryColor,
                        ),
                        onTap: () async {
                          widget.model?.selectNewAdress(adress);
                          navigationService.back();
                          widget.model?.initialiseMapForm(
                            initialisationData: {
                              'adress': adress,
                              'newAdress': false,
                              'coordinates': adress.latLng,
                              'reload': true
                            },
                          );
                        });
              },
            ),
    );
  }
}
