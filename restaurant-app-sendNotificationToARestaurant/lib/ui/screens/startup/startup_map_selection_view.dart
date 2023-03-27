// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_app/ui/screens/startup/startup_map_selection_viewmodel.dart';
import 'package:stacked/stacked.dart';

// Project imports:

import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';

class StartupMapSelectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupMapSelectionViewModel>.reactive(
      viewModelBuilder: () => StartupMapSelectionViewModel(),
      onModelReady: (model) {
        model.initialiseMap();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: model.onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Selectionner votre adresse',
              style: Theme.of(context).appBarTheme.toolbarTextStyle,
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: FullFlatButton(
              title: 'Confirmer',
              onPress: model.confirmePosition,
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
            ],
          ),
        ),
      ),
    );
  }
}
