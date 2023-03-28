// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_adresses/adresses_view_model.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';

class AdressMapSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AdressesViewModel>.reactive(
      viewModelBuilder: () => AdressesViewModel(),
      onModelReady: (model) {
        model.initialiseMap();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Selectionnez votre adresse',
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: FullFlatButton(
            title: 'Confirmer',
            onPress: () async {
              var backResult = await navigationService
                  .navigateTo(Routes.adressFormScreen, arguments: {
                'coordinates': model.markers.single.position,
                'newAdress': true
              });

              if (backResult['active']) {
                navigationService.back(result: {
                  'active': backResult['active'],
                  'message': backResult['message']
                });
              }
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              child: GoogleMap(
                markers: model.markers,
                onCameraMove: (CameraPosition cameraPosition) {
                  model.updateMarkerPosition(cameraPosition);
                },
                onTap: (LatLng latLng) {},
                compassEnabled: true,
                onMapCreated: model.onMapCreated,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: model.initialPosition,
                  zoom: 15,
                ),
                zoomControlsEnabled: false,
                mapToolbarEnabled: true,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, right: 10),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: IconButton(
                      icon: Icon(
                        Icons.my_location,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: null),
                  onPressed: model.getLocation,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
