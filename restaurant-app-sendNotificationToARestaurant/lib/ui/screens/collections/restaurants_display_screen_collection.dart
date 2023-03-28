// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked_services/stacked_services.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/models/collection.dart';
import 'package:restaurant_app/ui/widgets/collection/view_models/collections.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/restaurants_display_list_collection.dart';
import 'package:restaurant_app/ui/widgets/uielements/empty_list.dart';

class RestaurantsDisplayCollectionScreen extends StatelessWidget {
  static const String routeName = '/restaurants-collection-display';

  @override
  Widget build(BuildContext context) {
    Collection collection =
        ModalRoute.of(context)?.settings.arguments as Collection;
    return Scaffold(
      appBar: AppBar(
        actions: [
          collection.isDefault!
              ? Text('')
              : IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    DialogResponse? response = await locator<DialogService>()
                        .showDialog(
                            title: 'Supression de ${collection.title}',
                            description:
                                'Cette collection sera definitivement supprimée. Voulez-vous continuer ?',
                            cancelTitle: 'Annuler',
                            cancelTitleColor: Colors.red,
                            buttonTitle: 'Oui');

                    if (!response!.confirmed) return;

                    locator<CollectionModel>()
                        .deleteUserCollection(collection.id!, true);
                  },
                )
        ],
        title: Text(
          collection.title!,
          style: Theme.of(context).appBarTheme.toolbarTextStyle,
        ),
      ),
      body: Container(
        child: collection.restaurantIds?.length == 0
            ? EmptyList(
                sign: Icon(
                  Icons.no_meals,
                  color: Colors.grey[400],
                  size: 150,
                ),
                message: 'Rien à afficher pour le moment...',
              )
            : RestaurantsDisplayListCollection(
                restaurantsIds: collection.restaurantIds!,
              ),
      ),
    );
  }
}
