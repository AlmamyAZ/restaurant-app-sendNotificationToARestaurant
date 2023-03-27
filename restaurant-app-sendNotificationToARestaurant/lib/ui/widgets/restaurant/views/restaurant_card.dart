// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';
import '../../uielements/location_chip.dart';
import '../../uielements/open_status_chip.dart';
import '../../uielements/stars_chip.dart';

class RestaurantCard extends StatelessWidget {
  final String? id;
  final bool? grid;
  final String? name;
  final String? phoneNumber;
  final String? adress;
  final String? imageUrl;
  final List<Map<String, dynamic>>? kitchenSpeciality;
  final double? rating;
  final String? imageHash;
  final bool? openStatus;
  final List<Map<String, dynamic>>? openHours;

  const RestaurantCard({
    Key? key,
    this.id,
    this.grid = false,
    this.name,
    this.openStatus,
    this.openHours,
    this.adress,
    this.rating,
    this.imageUrl,
    this.kitchenSpeciality,
    this.imageHash,
    this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey(key),
      onTap: () {
        pushWithPopRestartRestaurantId(
            id!, name!, imageUrl!, imageHash!, openHours!, phoneNumber!);
      },
      child: Container(
          width: 200,
          padding: grid! ? null : EdgeInsets.only(right: 15),
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
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                      height: 115,
                      width: double.infinity,
                      child: CachedImageNetwork(
                          image: imageUrl!, imageHash: imageHash!),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OpenStatusChip(isOpen(openHours!)),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                name!,
                style: Theme.of(context).textTheme.headline6,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                flattenMapToString(kitchenSpeciality!),
                style: Theme.of(context).textTheme.subtitle1,
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StarsChip(
                    icon: Icons.star,
                    color: Colors.yellow[800]!,
                    text: rating.toString(),
                  ),
                  LocationChip(
                    icon: Icons.location_on,
                    color: Colors.black87,
                    fontSize: 12,
                    text: adress!,
                  )
                ],
              )
            ],
          )),
    );
  }
}
