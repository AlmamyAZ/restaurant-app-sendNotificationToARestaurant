// Dart imports:

// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/photo_management_view_model.dart';
import 'package:restaurant_app/ui/widgets/uielements/filter_element.dart';

class PhotoReviewScreen extends StatelessWidget {
  final description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return ViewModelBuilder<PhotoManagementViewModel>.reactive(
      onModelReady: (model) => model.verifyImage(arguments['asset']),
      viewModelBuilder: () => PhotoManagementViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: Text('Ajouter une photo'),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (model.isUploadingImage) return;
                  await model.savePhotoReview(
                    asset: arguments['asset'],
                    description: description.text,
                    restaurantId: arguments['restaurantId'],
                  );

                  // Navigator.pop(context);
                },
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                var haveToQuitScreen = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Voulez vous quitter ?",
                      ),
                      content:
                          Text("Toutes vos modifications seront supprimées"),
                      actions: [
                        TextButton(
                          child: Text(
                            "Annuler",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        TextButton(
                          child: Text(
                            "Oui",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
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
                    'Bambo',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  verticalSpaceSmall,

                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Opacity(
                        opacity: model.isUploadingImage ? 0.3 : 1,
                        child: Center(
                          child: Container(
                            width: 300,
                            height: 300,
                            child: Image.file(
                              File(arguments['asset'].path),
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: model.isUploadingImage ? 1 : 0,
                        child: CircularProgressIndicator(
                          value: model.downloadProgress,
                          backgroundColor: Colors.grey,
                          // valueColor: Theme.of(context).primaryColor, //fix this
                        ),
                      ),
                    ],
                  ),
                  model.isImageValid
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'l\'image depasse 3MB, veuillez choisir une autre image',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                            ),
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
                    enabled: model.isUploadingImage ? false : true,
                    controller: description,
                    maxLines: 3,
                    // style: TextStyle(fontWeight: FontWeight.w500),
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText:
                            "ex: j'ai aimé , les prix sont abordables..."),
                  ),
                  // Divider(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChipList extends ViewModelWidget<PhotoManagementViewModel> {
  ChipList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, PhotoManagementViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A propos de quoi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          Container(
            height: 55,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterElement(
                  label: 'Menu',
                  setIndexHandler: model.setSelectedIndex,
                  selectedIndex: model.selectedIndex,
                  idx: 0,
                ),
                FilterElement(
                  label: 'Etablissement',
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
