// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/review.dart';
import 'package:restaurant_app/ui/bottomSheet/item.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/review.dart';

class ReviewBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const ReviewBottomSheet({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _ReviewBottomSheetState createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  bool busy = false;

  bool isForTheUser(userId) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return currentUserId == userId;
  }

  @override
  Widget build(BuildContext context) {
    Review review = widget.request.data['review'];
    String? userId = review.userId;

    return ViewModelBuilder<ReviewModel>.nonReactive(
        disposeViewModel: false,
        viewModelBuilder: () => locator<ReviewModel>(),
        builder: (context, model, child) => Container(
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
                    hasNext: false,
                    icon: Icons.edit,
                    text: 'Editer',
                    onTap: () {
                      model.gotoRatingReviewScreen(review);
                    },
                    show: isForTheUser(userId),
                  ),
                  Item(
                    show: !isForTheUser(userId),
                    hasNext: false,
                    icon: Icons.flag,
                    text: 'Signaler',
                    onTap: () {
                      if (busy) return;
                      model.reportReview(review);
                    },
                  ),
                  Item(
                    show: isForTheUser(userId),
                    icon: Icons.delete,
                    text: 'supprimer',
                    onTap: () async {
                      if (busy) return;
                      DialogResponse? response = await dialogService.showDialog(
                        title: "Supression de l'avis",
                        description:
                            "la suppression de l'avis sera définitive. Voulez-vous continuer ?",
                        cancelTitle: 'Annuler',
                        cancelTitleColor: Colors.red,
                        buttonTitle: 'Oui',
                      );

                      if (!response!.confirmed) return;
                      setState(() {
                        busy = true;
                      });
                      await model.deleteReview(review);
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
            ));
  }
}
