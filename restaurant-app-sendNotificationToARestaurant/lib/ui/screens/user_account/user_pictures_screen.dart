// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/models/image.dart' as ImageModel;
import 'package:restaurant_app/ui/widgets/restaurant/view_models/photo.dart';
import 'package:restaurant_app/ui/widgets/uielements/empty_list.dart';
import 'package:restaurant_app/ui/widgets/uielements/photo_gallery_grid.dart';

class UserPicturesScreen extends StatelessWidget {
  GalleryGrid buildSliverGridBody(List<ImageModel.Image> images, bool isBusy) {
    return GalleryGrid(
      menuImages: isBusy ? [] : images,
      skeleton: GaleryGridSkeleton(),
      busy: isBusy,
      editable: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PhotoModel>.reactive(
        viewModelBuilder: () => locator<PhotoModel>(),
        disposeViewModel: false, // to remove after you change the viewmodel
        onModelReady: (model) {
          model.fetchUserPicture();
        },
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text(
                  'Photos',
                  style: Theme.of(context).appBarTheme.toolbarTextStyle,
                ),
              ),
              body:
                  !model.busy(model.userPhotos) && model.userPhotos.length == 0
                      ? EmptyList(
                          sign: Icon(
                            Icons.no_photography,
                            color: Colors.grey[400],
                            size: 150,
                          ),
                          message: 'Rien à afficher pour le moment',
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: buildSliverGridBody(
                            model.userPhotos,
                            model.busy(model.userPhotos),
                          ),
                        ),
            ));
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
