// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_slider.dart';

// Project imports:
import 'package:restaurant_app/core/models/slider.dart' as MySliders;
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';

List<Widget> getImagesSliders(
    List<MySliders.Slider> sliders, Function onPress) {
  return sliders
      .map((item) => SliderItem(item: item, onPress: onPress))
      .toList();
}

class SliderItem extends StatelessWidget {
  final MySliders.Slider item;
  final Function onPress;

  const SliderItem({
    required this.item,
    required this.onPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress(item);
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: 600,
            height: double.infinity,
            child: CachedImageNetwork(
                image: item.imageUrl!, imageHash: item.imageHash!),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // width: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(0, 0, 0, 0),
                    Color.fromARGB(200, 0, 0, 0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: Container(
              // width: 300,
              width: screenWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.type != '')
                    FittedBox(
                      child: Text(
                        item.typeLabel!,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  FittedBox(
                    child: Text(
                      item.title!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (item.subtitle != '')
                    SizedBox(
                      width: 280,
                      child: Text(
                        item.subtitle!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  final List<MySliders.Slider> sliders;
  final Function onPress;

  ImageCarousel({required this.sliders, required this.onPress});
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          items: getImagesSliders(widget.sliders, widget.onPress),
          options: CarouselOptions(
              viewportFraction: orientationIsPortrait(context) ? 1 : 0.8,
              height: 400,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.sliders.map((url) {
              int index = widget.sliders.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Colors.white.withOpacity(0.9)
                      : Colors.white.withOpacity(0.4),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
