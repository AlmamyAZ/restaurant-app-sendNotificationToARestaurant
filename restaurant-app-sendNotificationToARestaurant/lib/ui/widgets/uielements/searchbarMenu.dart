// Flutter imports:
import 'package:flutter/material.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/search_all_restaurants/restaurants_search_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';
import 'package:stacked/stacked.dart';
import 'package:restaurant_app/core/models/menu.dart' as menu;

import 'package:restaurant_app/ui/widgets/uielements/empty_list.dart';

class SearchBarMenu extends StatelessWidget {
  const SearchBarMenu({
    required this.restaurantId,
    Key? key,
  }) : super(key: key);

  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.0),
      child: IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showSearch(
              context: context,
              useRootNavigator: true,
              delegate: SearchBarDelegate(restaurantId: restaurantId));
        },
        iconSize: 30.0,
      ),
    );
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  SearchBarDelegate({
    required this.restaurantId,
    Key? key,
  });

  final String restaurantId;

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
        model.searchItems(query, restaurantId);
      },
      disposeViewModel: false,
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => SafeArea(
        child: Column(
          children: [
            ResultList(restaurantId: restaurantId),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
    // return ListView.builder(
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
  ResultList({
    required this.restaurantId,
    Key? key,
  });

  final String restaurantId;

  @override
  Widget build(BuildContext context, RestaurantsSearchViewModel model) {
    bool isListEmpty =
        !model.busy(model.menuItems) && model.menuItems?.length == 0;
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
              itemCount:
                  model.busy(model.menuItems) ? 10 : model.menuItems?.length,
              itemBuilder: (ctx, idx) {
                menu.MenuItem item = model.busy(model.menuItems)
                    ? menu.MenuItem()
                    : model.menuItems![idx];

                logger.i('item: ${item.id}');
                return model.busy(model.menuItems)
                    ? Container()
                    : InkWell(
                        onTap: () {
                          navigationService.navigateTo(
                              Routes.menuItemDetailsScreen,
                              arguments: {
                                'menuItem': item,
                                'restaurantId': restaurantId,
                                'menuSectionId': item.sectionId,
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              item.alias!,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.description!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                verticalSpaceSmall,
                                Text(
                                  formatCurrency(item.price!.toDouble()),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            trailing: Container(
                              width: screenWidth(context) / 4,
                              child: Hero(
                                tag: item.id!,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    child: CachedImageNetwork(
                                        image: item.imageUrl200!,
                                        imageHash: item.imageHash!),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ),
    );
  }
}
