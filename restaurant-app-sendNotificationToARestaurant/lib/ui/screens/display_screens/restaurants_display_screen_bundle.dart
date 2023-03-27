// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../widgets/restaurant/views/restaurants_display_list_bundle.dart';

class RestaurantsDisplayBundleScreen extends StatelessWidget {
  static const String routeName = '/restaurants-bundle-display';

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
        child: RestaurantsDisplayListBundle(
          establishmentId: arguments['id'],
        ),
      ),
    );
  }
}
