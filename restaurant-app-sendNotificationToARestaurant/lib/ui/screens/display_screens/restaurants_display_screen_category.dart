// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/widgets/restaurant/views/restaurants_display_list_category.dart';

class RestaurantsDisplayCategoryScreen extends StatelessWidget {
  static const String routeName = '/restaurants-category-display';

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          arguments['name'],
          style: Theme.of(context).appBarTheme.toolbarTextStyle,
        ),
      ),
      body: Container(
        child: RestaurantsDisplayListCategory(
          id: arguments['id'],
        ),
      ),
    );
  }
}
