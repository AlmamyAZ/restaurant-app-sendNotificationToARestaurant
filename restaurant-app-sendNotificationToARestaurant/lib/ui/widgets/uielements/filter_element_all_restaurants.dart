// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/search_all_restaurants/restaurants_list_view_model.dart';
import 'filter_modal.dart';

class FilterElementAllRestaurants
    extends ViewModelWidget<AllRestaurantsViewModel> {
  final String label;
  final Function setIndexHandler;
  final int selectedIndex;
  final int idx;

  FilterElementAllRestaurants({
    required this.label,
    required this.setIndexHandler,
    required this.selectedIndex,
    required this.idx,
  });

  @override
  Widget build(BuildContext context, AllRestaurantsViewModel model) {
    return GestureDetector(
      onTap: () {
        if (idx == 0) {
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return FilterModal(model: model);
              });

          return;
        }
        if (idx == selectedIndex) return;
        setIndexHandler(idx);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        // Provide an optional curve to make the animation feel smoother.
        curve: Curves.easeIn,
        transform: idx == selectedIndex
            ? new Matrix4.identity().scaled(1.0, 1.0)
            : new Matrix4.identity().scaled(0.9, 0.9),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: idx == selectedIndex
              ? Theme.of(context).primaryColor
              : Colors.white,
        ),
        child: Row(children: [
          idx == 0
              ? Row(
                  children: [
                    Icon(
                      Icons.sort,
                      color: idx == selectedIndex ? Colors.white : Colors.black,
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                )
              : Text(''),
          Text(
            label,
            style: TextStyle(
              color: idx == selectedIndex
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
    );
  }
}
