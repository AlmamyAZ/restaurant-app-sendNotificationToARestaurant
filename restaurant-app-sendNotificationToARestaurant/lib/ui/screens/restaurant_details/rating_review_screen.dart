// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/rate_review_view_model.dart';
import 'package:restaurant_app/ui/widgets/uielements/busy_widget.dart';
import 'package:restaurant_app/ui/widgets/uielements/filter_element.dart';

class RatingReviewScreen extends StatelessWidget {
  static const String routeName = '/review-restaurant';

  Widget _buildListView({RateReviewViewModel? model}) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: model!.images.length,
      itemBuilder: (ctx, index) {
        XFile asset = model.images[index];

        return Container(
          width: 300,
          height: 300,
          child: Image.file(
            File(asset.path),
          ),
        );
      },
    );
  }

  Future<void> loadAssets({RateReviewViewModel? model}) async {
    List<XFile>? resultList = [];

    try {
      resultList = await model!.pickPicture();
    } on Exception catch (e) {
      print(e);
    }

    model!.setImages = resultList;
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    dynamic restaurantId = arguments['restaurantId'];
    dynamic review = arguments['review'];
    dynamic name = arguments['name'];

    return ViewModelBuilder<RateReviewViewModel>.reactive(
      viewModelBuilder: () => RateReviewViewModel(review),
      onModelReady: (model) {},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Ajouter une note'),
          actions: [
            BusySmallWidget(
              busy: model.isLoading,
              child: IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () async {
                  model.isEdit
                      ? await model.editReview()
                      : await model.addReview(
                          model.description.text, restaurantId);
                },
              ),
            ),
          ],
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              var haveToQuitScreen = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Voulez-vous quitter ?"),
                    content: Text("Toutes vos modifications seront supprimées"),
                    actions: [
                      TextButton(
                        child: Text(
                          "Annuler",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: Text(
                          "Oui",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                      )
                    ],
                  );
                },
              );

              if (haveToQuitScreen == null || !haveToQuitScreen) {
                return;
              }

              if (haveToQuitScreen) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                verticalSpaceSmall,
                Divider(), //
                Text(
                  'Donner une note',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RatingBar.builder(
                    initialRating: model.reviewStart,
                    minRating: 1,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 40.0,
                    direction: Axis.horizontal,
                    onRatingUpdate: (rate) => model.setReviewStart(rate),
                  ),
                ),
                Divider(),
                verticalSpaceTiny,
                ChipList(),
                Text('Ajouter une description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                TextField(
                  controller: model.description,
                  maxLines: 3,
                  // style: TextStyle(fontWeight: FontWeight.w500),
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      hintText: "ex: j'ai aimé , les prix sont abordables..."),
                ),
                verticalSpaceMedium,
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ajouter une photo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          var numberOfpicture =
                              model.currentReview?.imagesLinks?.length;
                          if (numberOfpicture != null) {
                            if (numberOfpicture >= 3) {
                              model.showSnacbar(
                                "limite d'images",
                                "vous avez atteint le nombre maximum d'images",
                              );
                              return;
                            }
                          }

                          loadAssets(model: model);
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          color: Colors.grey.withOpacity(0.3),
                          padding: EdgeInsets.all(20),
                          child: Icon(Icons.camera_enhance),
                        ),
                      ),
                      Container(
                        height: 100,
                        child: _buildListView(model: model),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChipList extends ViewModelWidget<RateReviewViewModel> {
  ChipList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, RateReviewViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'À propos de ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Container(
            height: 55,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterElement(
                  label: 'Personnel',
                  setIndexHandler: model.setSelectedIndex,
                  selectedIndex: model.selectedIndex,
                  idx: 0,
                ),
                FilterElement(
                  label: 'Établissement',
                  setIndexHandler: model.setSelectedIndex,
                  selectedIndex: model.selectedIndex,
                  idx: 1,
                ),
                FilterElement(
                  label: 'Nourriture',
                  setIndexHandler: model.setSelectedIndex,
                  selectedIndex: model.selectedIndex,
                  idx: 2,
                ),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
