// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/widgets/collection/skeletons/collection_item_skeleton.dart';
import 'package:restaurant_app/ui/widgets/collection/view_models/collections.dart';
import '../../../core/models/collection.dart';
import '../../widgets/collection/views/collection_item.dart';
import '../../widgets/collection/views/new_collection_item.dart';

class RestaurantsCollectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Collections',
          style: Theme.of(context).textTheme.headline5?.copyWith(
                color: Colors.white,
              ),
        ),
        actions: [
          IconButton(
            highlightColor: Theme.of(context).primaryColor,
            splashColor: Theme.of(context).colorScheme.secondary,
            icon: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () =>
                locator<CollectionModel>().showAddNewCollectionModal(context),
          )
        ],
      ),
      body: ViewModelBuilder<CollectionModel>.reactive(
        viewModelBuilder: () => locator<CollectionModel>(),
        disposeViewModel: false,
        builder: (context, model, child) {
          List<Collection> userCollections = !model.dataReady
              ? List.generate(5, (index) => Collection())
              : model.userCollections;

          return GridView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(25),
            children: [
              ...userCollections
                  .map((catData) => !model.dataReady
                      ? CollectionItemSkeleton()
                      : CollectionItem(
                          collection: catData,
                        ))
                  .toList(),
              NewCollectionItem(showModal: model.showAddNewCollectionModal),
            ],
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
          );
        },
      ),
    );
  }
}
