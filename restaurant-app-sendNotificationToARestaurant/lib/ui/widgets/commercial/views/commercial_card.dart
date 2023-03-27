// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

// Project imports:
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';

class CommercialCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final Function() onPress;

  final String imageHash;

  const CommercialCard({
    Key? key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.imageHash,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var gradiant = GradientColors.heavyRain;

    switch (title) {
      case 'Facebook':
        gradiant = GradientColors.skyLine;
        break;
      case 'Instagram':
        gradiant = MoreGradientColors.instagram;
        break;
      case 'Madifood':
        gradiant = GradientColors.crystalline;
        break;
      default:
    }

    final Shader linearGradient = LinearGradient(
      colors: gradiant,
    ).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return InkWell(
      onTap: onPress,
      child: Container(
          width: orientationIsPortrait(context)
              ? screenWidth(context) / 1.3
              : screenWidth(context) / 2,
          padding: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      child: CachedImageNetwork(
                          image: imageUrl, imageHash: imageHash),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                            colors: <Color>[
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(5))),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    fontSize: 25,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(5, 5),
                                        blurRadius: 10.0,
                                        color: Color.fromARGB(10, 0, 0, 0),
                                      ),
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 5.0,
                                        color: Color.fromARGB(50, 0, 0, 0),
                                      ),
                                    ],
                                    foreground: new Paint()
                                      ..shader = linearGradient,
                                  ),
                        ),
                        Text(
                          subtitle,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
