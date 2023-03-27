// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/home/home_view_model.dart';
import 'package:restaurant_app/ui/widgets/bundle/skeletons/bundles_skeleton.dart';
import '../../../../core/models/bundle.dart';
import 'bundle_item.dart';

class Bundles extends ViewModelWidget<HomeViewModel> {
  const Bundles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return model.busy(model.bundles)
        ? BundlesSkeleton()
        : SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  Bundle bundle = model.bundles![index];
                  return BundleItem(
                    id: bundle.id!,
                    name: bundle.name!,
                    image: bundle.imageUrl!,
                    imageHash: bundle.imageHash!,
                    hasCategories: bundle.hasCategories!,
                    categories: bundle.categories!,
                  );
                },
                childCount: model.bundles?.length,
              ),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 4 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
            ),
          );
  }
}
