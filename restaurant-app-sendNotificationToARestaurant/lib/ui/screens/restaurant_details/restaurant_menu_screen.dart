// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';
import 'package:restaurant_app/ui/widgets/uielements/searchbarMenu.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/menu.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/restaurant_presentation.dart';
import 'package:restaurant_app/ui/widgets/uielements/photo_gallery.dart';
import '../../widgets/restaurant/views/menu_list.dart';

class RestaurantMenuScreen
    extends ViewModelWidget<BottomTabsRestaurantViewModel> {
  final String note =
      "Les prix de l'integralité des elements de ce menu sont exclusivement et directement controlés par l'etablissement \"le restaurant\" et non par Restaurant App";
  @override
  Widget build(
    BuildContext context,
    BottomTabsRestaurantViewModel restaurantModel,
  ) {
    return ViewModelBuilder<MenuModel>.reactive(
        viewModelBuilder: () => locator<MenuModel>(),
        onModelReady: (model) {
          if (!restaurantModel.isBusy) {
            model.fetchMenuByRestaurantId(restaurantModel.id!);
          }
        },
        disposeViewModel: false,
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Menu',
                style: Theme.of(context).appBarTheme.toolbarTextStyle,
              ),
              actions: [
                SearchBarMenu(restaurantId: restaurantModel.id!),
              ],
            ),
            body: CustomScrollView(slivers: [
              SliverPadding(
                padding: EdgeInsets.all(10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      RestaurantPresentation(),
                      RestaurantMenuPhotos(),
                      Divider(),
                    ],
                  ),
                ),
              ),
              MenuList(
                  menuSections: model.isBusy ? [] : model.menu!.menuSections!,
                  restaurantId: restaurantModel.id!),
              SliverPadding(
                padding: EdgeInsets.all(10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Divider(),
                      Text(
                        model.isBusy ? '' : this.note,
                        style: TextStyle(fontSize: 12),
                      ),
                      verticalSpaceLarge
                    ],
                  ),
                ),
              ),
            ])));
  }
}

class RestaurantMenuPhotos extends ViewModelWidget<MenuModel> {
  @override
  Widget build(BuildContext context, MenuModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos du menu',
          style: Theme.of(context).appBarTheme.toolbarTextStyle,
        ),
        verticalSpaceSmall,
        Gallery(
          busy: model.isBusy,
          skeleton: MenuPhotosItemSkeleton(),
          verticalGallery: false,
          menuImages: model.isBusy ? [] : model.menu!.menuImages,
        )
      ],
    );
  }
}

class MenuPhotosItemSkeleton extends StatelessWidget {
  static const String routeName = '/restaurants-specialities';

  @override
  Widget build(BuildContext context) {
    return ContentPlaceholder(
      width: double.infinity,
      height: double.infinity,
      spacing: EdgeInsets.all(0),
      child: ContentPlaceholder.block(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
