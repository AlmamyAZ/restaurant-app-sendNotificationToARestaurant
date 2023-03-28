// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked_services/stacked_services.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/bottomSheet/item.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/photo.dart';

class GalleryBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const GalleryBottomSheet({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _GalleryBottomSheetState createState() => _GalleryBottomSheetState();
}

class _GalleryBottomSheetState extends State<GalleryBottomSheet> {
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    String restaurantId = widget.request.customData['restaurantId'];
    String imageId = widget.request.customData['imageId'];
    String imageUrl = widget.request.customData['imageUrl'];
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Item(
            icon: Icons.restaurant,
            text: 'Voir la boutique',
            onTap: () {
              if (busy) return;

              navigationService.navigateTo(
                Routes.bottomTabsRestaurant,
                arguments: restaurantId,
              );
            },
          ),
          Item(
            icon: Icons.delete,
            text: 'supprimer',
            onTap: () async {
              if (busy) return;

              DialogResponse? response = await dialogService.showDialog(
                  title: 'Supression de photo',
                  description:
                      'Cette photo sera définitivement supprimée. Voulez-vous continuer ?',
                  cancelTitle: 'Annuler',
                  cancelTitleColor: Colors.red,
                  buttonTitle: 'Oui');

              if (!response!.confirmed) return;

              setState(() {
                busy = true;
              });

              await locator<PhotoModel>()
                  .deletePicture(restaurantId, imageId, imageUrl);
              widget.completer(SheetResponse(
                confirmed: true,
              ));
              setState(() {
                busy = false;
              });
            },
            hasNext: false,
            logout: true,
            busy: busy,
          ),
        ],
      ),
    );
  }
}
