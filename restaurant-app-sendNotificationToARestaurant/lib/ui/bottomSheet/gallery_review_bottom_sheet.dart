// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked_services/stacked_services.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/bottomSheet/item.dart';

class GalleryReviewBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const GalleryReviewBottomSheet({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _GalleryReviewBottomSheetState createState() =>
      _GalleryReviewBottomSheetState();
}

class _GalleryReviewBottomSheetState extends State<GalleryReviewBottomSheet> {
  bool busy = false;

  bool isForTheUser(userId) {
    String? currentUserId = firebaseAuth.currentUser?.uid;

    return currentUserId == userId;
  }

  @override
  Widget build(BuildContext context) {
    Function deleteFunction = widget.request.customData['deleteFunction'];
    String reviewUserId = widget.request.customData['reviewUserId'];

    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Item(
            show: isForTheUser(reviewUserId),
            icon: Icons.delete,
            text: 'supprimer',
            onTap: () async {
              if (busy) return;

              DialogResponse? response = await dialogService.showDialog(
                  title: 'Supression de photo',
                  description:
                      'Cette photo sera définitivement supprimée. Voulez-vous continuer ?',
                  cancelTitle: 'Annuler',
                  cancelTitleColor: Colors.red,
                  buttonTitle: 'Oui');

              if (!response!.confirmed) return;

              setState(() {
                busy = true;
              });

              await deleteFunction();
              widget.completer(SheetResponse(
                confirmed: true,
              ));
              setState(() {
                busy = false;
              });
            },
            hasNext: false,
            logout: true,
            busy: busy,
          ),
        ],
      ),
    );
  }
}
