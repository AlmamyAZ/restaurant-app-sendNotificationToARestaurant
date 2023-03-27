// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/food/food_view_model.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';
import '../../uielements/stars_chip.dart';

class FoodHeader extends ViewModelWidget<FoodViewModel> {
  final Map<String, dynamic> foodItem;
  const FoodHeader({
    required this.foodItem,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, FoodViewModel model) {
    return FlexibleSpaceBar(
      stretchModes: [StretchMode.blurBackground],
      titlePadding: EdgeInsets.all(0),
      centerTitle: true,
      collapseMode: CollapseMode.parallax,
      background: Container(
        height: 250,
        color: Colors.white,
        child: Hero(
          tag: foodItem['id'],
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              //image code
              Container(
                constraints: BoxConstraints.expand(),
                child: CachedImageNetwork(
                    image: foodItem['imageUrl'],
                    imageHash: foodItem['imageHash']),
              ),

              //top grey shadow
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      end: const Alignment(0.0, 0.4),
                      begin: const Alignment(0.0, -1),
                      colors: <Color>[
                        Colors.black,
                        Colors.black12.withOpacity(0.0)
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      begin: const Alignment(0.0, 0.4),
                      end: const Alignment(0.0, -1),
                      colors: <Color>[
                        Colors.black.withOpacity(0.7),
                        Colors.black12.withOpacity(0.0)
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.busy(model.dish) ? "" : model.dish!.name!,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white, fontSize: 25),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      model.busy(model.dish) ? "" : model.dish!.speciality!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StarsChip(
                            icon: Icons.favorite,
                            color: Colors.red,
                            text: model.busy(model.dish)
                                ? ""
                                : '${model.dish?.likerCount.toString()} kiffs',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 40,
                bottom: 40,
                child: GestureDetector(
                  onTap: () {
                    model.likeDish();
                  },
                  child: Icon(
                    model.isLiked ? Icons.favorite : Icons.favorite_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
