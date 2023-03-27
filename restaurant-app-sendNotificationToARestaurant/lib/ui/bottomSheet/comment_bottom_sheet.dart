// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/review.dart';
import 'package:restaurant_app/ui/bottomSheet/item.dart';

class CommentBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const CommentBottomSheet({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  bool busy = false;

  bool isForTheUser(userId) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return currentUserId == userId;
  }

  @override
  Widget build(BuildContext context) {
    Review comment = widget.request.customData['comment'];
    Function deleteFunction = widget.request.customData['deleteFunction'];
    Function editFuction = widget.request.customData['editFunction'];
    Function reportFunction = widget.request.customData['reportFunction'];

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
            show: isForTheUser(comment.userId),
            hasNext: false,
            icon: Icons.edit,
            text: 'Editer',
            onTap: () {
              if (busy) return;
              editFuction();
              widget.completer(SheetResponse(data: {'edit': true}));
            },
          ),
          Item(
            show: !isForTheUser(comment.userId),
            hasNext: false,
            icon: Icons.edit,
            text: 'Signaler',
            onTap: () {
              if (busy) return;
              reportFunction();
            },
          ),
          Item(
            show: isForTheUser(comment.userId),
            icon: Icons.delete,
            text: 'supprimer',
            onTap: () async {
              if (busy) return;
              DialogResponse? response = await dialogService.showDialog(
                title: 'Supression du commentaire',
                description:
                    'la suppression sera de maniere definitive. Voulez vous continuer ?',
                cancelTitle: 'Annuler',
                cancelTitleColor: Colors.red,
                buttonTitle: 'Oui',
              );

              if (!response!.confirmed) return;
              setState(() {
                busy = true;
              });
              await deleteFunction();
              widget.completer(
                SheetResponse(
                  confirmed: true,
                ),
              );
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
