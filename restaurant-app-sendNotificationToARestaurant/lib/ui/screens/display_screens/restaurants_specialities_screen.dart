// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/widgets/category/view_models/categories.dart';
import 'package:restaurant_app/ui/widgets/restaurant/skeletons/speciality_item_skeleton.dart';
import '../../widgets/restaurant/views/speciality_item.dart';

class RestaurantsSpecialitiesScreen extends StatelessWidget {
  static const String routeName = '/restaurants-specialities';

  @override
  Widget build(BuildContext context) {
    var argument =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    List<String> categoriesId = argument['categories'];
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Type de cuisines',
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          ),
        ),
        body: ViewModelBuilder<CategoriesModel>.reactive(
            viewModelBuilder: () => CategoriesModel(),
            onModelReady: (model) =>
                model.fetchCategoriesForBundle(categoriesId),
            builder: (context, model, child) => GridView(
                  padding: const EdgeInsets.all(25),
                  children: model.isBusy
                      ? List<int>.filled(8, 1)
                          .map((e) => SpecialityItemSkeleton())
                          .toList()
                      : model.categoriesForBundle.map((specData) {
                          return SpecialityItem(
                            id: specData.id!,
                            title: specData.name!,
                            imgUrl: specData.imgUrl!,
                            imageHash: specData.imageHash!,
                            nbPlaces: specData.nbPlaces!,
                          );
                        }).toList(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),
                )));
  }
}
