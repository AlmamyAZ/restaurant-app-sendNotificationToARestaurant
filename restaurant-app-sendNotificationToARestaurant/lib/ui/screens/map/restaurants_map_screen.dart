// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurant_app/constants.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/screens/map/restaurants_map_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import '../../widgets/restaurant/views/restaurant_list_card_horizontal_map.dart';

class RestaurantsMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantsMapViewModel>.reactive(
      disposeViewModel: false,
      fireOnModelReadyOnce: true,
      onModelReady: (model) => model.initMap(),
      viewModelBuilder: () => locator<RestaurantsMapViewModel>(),
      builder: (context, model, child) {
        print('test ${model.showRestaurants}');
        var align = model.showRestaurants
            ? Align(
                alignment: Alignment.bottomCenter,
                child: RestaurantListCardHorizontalMap(),
              )
            : Container();

        return Stack(
          children: [
            Container(
              child: GoogleMap(
                markers: Set<Marker>.of(model.markers.values),
                onCameraMove: (CameraPosition cameraPosition) {
                  model.updatePosition(cameraPosition);
                },
                circles: Set<Circle>.from([
                  Circle(
                    circleId: CircleId('i'),
                    center: model.position,
                    radius: MAP_SEARCH_RADIUS,
                    strokeWidth: 2,
                    fillColor: primaryColor.withOpacity(0.15),
                    strokeColor: primaryColor.withOpacity(0.6),
                  )
                ]),
                onTap: model.hideCard,
                compassEnabled: true,
                onMapCreated: model.onMapCreated,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                mapType:
                    model.showSatelitte ? MapType.satellite : MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: model.position,
                  zoom: 15,
                ),
                zoomControlsEnabled: false,
                mapToolbarEnabled: true,
              ),
            ),
            align,
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, right: 10),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.my_location,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: model.getLocation,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 120.0, right: 10),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    model.showSatelitte ? Icons.layers : Icons.layers_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: model.setShowSatelitte,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  onPressed: model.searchRestaurant,
                  label: Text(
                    'Rechercher cette zone',
                    style: TextStyle(color: primaryColor, letterSpacing: 1),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
