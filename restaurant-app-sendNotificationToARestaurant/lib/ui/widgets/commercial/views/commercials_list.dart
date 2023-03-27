// Flutter imports:
import 'package:flutter/material.dart';
import 'package:restaurant_app/core/models/commercial.dart';
import 'package:restaurant_app/ui/widgets/commercial/skeletons/commercials_skeleton.dart';
import 'package:restaurant_app/ui/widgets/commercial/views/commercial_card.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/home/home_view_model.dart';

class CommercialsList extends ViewModelWidget<HomeViewModel> {
  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Quoi de neuf ?',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 150,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 10),
                scrollDirection: Axis.horizontal,
                itemCount: model.busy(model.commercials)
                    ? 5
                    : model.commercials!.length,
                itemBuilder: (ctx, idx) {
                  Commercial commercial = model.busy(model.commercials)
                      ? Commercial()
                      : model.commercials![idx];
                  return model.busy(model.commercials)
                      ? CommercialCardSkeleton()
                      : CommercialCard(
                          id: commercial.id!,
                          title: commercial.title!,
                          subtitle: commercial.subtitle!,
                          imageUrl: commercial.imageUrl!,
                          imageHash: commercial.imageHash!,
                          onPress: () {
                            model.navigateToSocial(commercial);
                          });
                },
              ))
        ],
      ),
    );
  }
}
