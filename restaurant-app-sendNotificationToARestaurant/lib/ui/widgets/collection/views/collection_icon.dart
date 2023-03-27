// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/widgets/collection/view_models/collection_icon_view_model.dart';

class CollectionIcon extends StatelessWidget {
  final String restaurantId;

  CollectionIcon({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CollectionIconViewModel>.reactive(
        viewModelBuilder: () =>
            CollectionIconViewModel(localRestaurantId: restaurantId),
        disposeViewModel: false,
        builder: (context, model, child) {
          return !model.value
              ? Icon(Icons.bookmark_border)
              : Icon(Icons.bookmark);
        });
  }
}
