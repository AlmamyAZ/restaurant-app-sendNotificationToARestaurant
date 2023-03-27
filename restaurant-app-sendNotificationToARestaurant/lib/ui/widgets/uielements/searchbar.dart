// Flutter imports:
import 'package:flutter/material.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/screens/search_all_restaurants/restaurants_search_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/restaurant_card_horizontal.dart';
import 'package:stacked/stacked.dart';

import 'package:restaurant_app/core/models/restaurant.dart';
import 'package:restaurant_app/ui/widgets/restaurant/skeletons/restaurant_card_horizontal_skeleton.dart';
import 'package:restaurant_app/ui/widgets/uielements/empty_list.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    this.scaleValue = 1,
    Key? key,
  }) : super(key: key);

  final double scaleValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.0 / scaleValue),
      child: Container(
        height: 50.0 / scaleValue,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0 / scaleValue),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 1,
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            showSearch(context: context, delegate: SearchBarDelegate());
          },
          child: TextField(
            enabled: false,
            cursorColor: Theme.of(context).primaryColor,
            textInputAction: TextInputAction.search,
            style: TextStyle(fontWeight: FontWeight.w500),
            decoration: InputDecoration(
                hintText: "Trouver un resto...",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17 / scaleValue,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  left: 15.0 / scaleValue,
                  top: 15.0 / scaleValue,
                  bottom: 15,
                ),
                fillColor: Theme.of(context).primaryColor,
                focusColor: Theme.of(context).primaryColor,
                hoverColor: Theme.of(context).primaryColor,
                prefixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                  iconSize: 30.0 / scaleValue,
                )),
            onChanged: (val) {},
            onSubmitted: (val) {},
          ),
        ),
      ),
    );
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      hintColor: Colors.white,
    );
  }

  @override
  String? get searchFieldLabel => 'Rechercher un plat';

  @override
  TextStyle? get searchFieldStyle => TextStyle(
        color: Colors.white,
      );

  @override
  InputDecorationTheme? get searchFieldDecorationTheme => InputDecorationTheme(
        labelStyle: TextStyle(
          color: Colors.red,
        ),
        hintStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(
          left: 15.0,
          top: 15.0,
          bottom: 15,
        ),
      );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          close(context, '');
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ViewModelBuilder<RestaurantsSearchViewModel>.reactive(
      viewModelBuilder: () => locator<RestaurantsSearchViewModel>(),
      onModelReady: (model) {
        model.searchRestaurants(query.trim());
      },
      disposeViewModel: false,
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => SafeArea(
        child: Column(
          children: [
            ResultList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // final suggestionList = query.isEmpty ? recentList : restaurantsCategories;
    return Container();
    // ListView.builder(
    //   itemBuilder: (context, index) => ListTile(
    //     onTap: () {
    //       print('query: $query');
    //       showResults(context);
    //     },
    //     leading: Icon(Icons.restaurant),
    //     title: RichText(
    //       text: TextSpan(
    //         text: suggestionList[index].substring(0, query.length),
    //         style: TextStyle(
    //           color: Colors.black,
    //           fontWeight: FontWeight.bold,
    //         ),
    //         children: [
    //           TextSpan(
    //             text: suggestionList[index].substring(query.length),
    //             style: TextStyle(
    //               color: Colors.grey,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    //   itemCount: suggestionList.length,
    // );
  }
}

class ResultList extends ViewModelWidget<RestaurantsSearchViewModel> {
  @override
  Widget build(BuildContext context, RestaurantsSearchViewModel model) {
    bool isListEmpty =
        !model.busy(model.restaurants) && model.restaurants?.length == 0;
    return Expanded(
      child: isListEmpty
          ? EmptyList(
              sign: Icon(
                Icons.no_meals,
                color: Colors.grey[400],
                size: 150,
              ),
              message: 'Rien à afficher pour le moment',
            )
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: model.busy(model.restaurants)
                  ? 10
                  : model.restaurants?.length,
              itemBuilder: (ctx, idx) {
                Restaurant restaurant = model.busy(model.restaurants)
                    ? Restaurant()
                    : model.restaurants![idx];
                return model.busy(model.restaurants)
                    ? RestaurantCardHorizontalSkeleton()
                    : RestaurantCardHorizontal(
                        kitchenSpeciality: restaurant.kitchenSpeciality!,
                        adress: restaurant.adress!,
                        id: restaurant.id!,
                        imageHash: restaurant.imageHash!,
                        imageUrl: restaurant.imageUrl!,
                        name: restaurant.name!,
                        openHours: restaurant.openHours!,
                        rating: restaurant.rating!,
                        phoneNumber: restaurant.phoneNumber!,
                        openStatus: restaurant.openStatus,
                        ratingCount: restaurant.ratingCount!,
                        getDistance: () =>
                            model.getDistance(restaurant.position!),
                      );
              },
            ),
    );
  }
}
