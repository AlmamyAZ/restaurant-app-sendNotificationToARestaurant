// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/models/image.dart' as ImageModel;
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/photo.dart';
import 'package:restaurant_app/ui/widgets/uielements/photo_gallery_grid.dart';
import '../../widgets/restaurant/views/restaurant_presentation.dart';

class RestaurantPhotosScreen
    extends ViewModelWidget<BottomTabsRestaurantViewModel> {
  @override
  Widget build(
      BuildContext context, BottomTabsRestaurantViewModel restaurantModel) {
    return Scaffold(
      appBar: buildAppBarFixed(context),
      body: DefaultTabController(
        length: 4,
        child: ViewModelBuilder<PhotoModel>.reactive(
          viewModelBuilder: () => locator<PhotoModel>(),
          onModelReady: (model) {
            if (!restaurantModel.isBusy) {
              model.runInitPhotosFetching(restaurantModel.id!);
            }
          },
          disposeViewModel: false,
          builder: (context, model, child) => NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                buildSliverToBoxAdapterHeader(
                    context, model, restaurantModel.id!),
                buildSliverAppBarCollepse(context, model),
              ];
            },
            body: TabBarView(
              children: [
                buildSliverGridBody(
                  model.allPhotos,
                  model.busy(model.allPhotos),
                ),
                buildSliverGridBody(
                  model.foodPhotos,
                  model.busy(model.foodPhotos),
                ),
                buildSliverGridBody(
                  model.restaurantPhotos,
                  model.busy(model.restaurantPhotos),
                ),
                buildSliverGridBody(
                  model.menuPhotos,
                  model.busy(model.menuPhotos),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBarFixed(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        'Photos',
        style: Theme.of(context).appBarTheme.toolbarTextStyle,
      ),
    );
  }

  SliverToBoxAdapter buildSliverToBoxAdapterHeader(
      BuildContext context, PhotoModel model, String restaurantId) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RestaurantPresentation(),
            verticalSpaceTiny,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Photos',
                  style: Theme.of(context).appBarTheme.toolbarTextStyle,
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(5),
                          top: Radius.circular(5),
                        ),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () {
                    model.pickPicture(restaurantId);
                  },
                  icon: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Ajouter photo',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            verticalSpaceTiny,
          ],
        ),
      ),
    );
  }

  SliverAppBar buildSliverAppBarCollepse(
      BuildContext context, PhotoModel model) {
    Widget _buildChip(String text) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline6?.copyWith(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      );
    }

    return SliverAppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      pinned: true,
      title: TabBar(
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 10),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 4.0,
        indicatorPadding: EdgeInsets.all(0),
        tabs: [
          Tab(child: _buildChip('Tous (${model.allPhotos.length})')),
          Tab(child: _buildChip('Nourriture (${model.foodPhotos.length})')),
          Tab(
              child: _buildChip(
                  'Etablissement (${model.restaurantPhotos.length})')),
          Tab(child: _buildChip('Menu (${model.menuPhotos.length})')),
        ],
      ),
    );
  }

  GalleryGrid buildSliverGridBody(List<ImageModel.Image> images, bool isBusy) {
    return GalleryGrid(
        menuImages: isBusy ? [] : images,
        skeleton: GaleryGridSkeleton(),
        busy: isBusy);
  }
}

class GaleryGridSkeleton extends StatelessWidget {
  const GaleryGridSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        children: List.generate(
          18,
          (idx) => ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              child: ContentPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }
}
