// Flutter imports:
import 'package:flutter/material.dart';

class NewCollectionItem extends StatelessWidget {
  NewCollectionItem({required this.showModal});
  final Function showModal;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      splashColor: Theme.of(context).primaryColor,
      onTap: () => showModal(context),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Stack(children: [
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.add,
              size: 40,
              color: Theme.of(context).primaryColor.withOpacity(0.4),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ajouter Collection',
                maxLines: 2,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 23,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ]),
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 3,
            ),
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.7), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
