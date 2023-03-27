// Package imports:
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';

@lazySingleton
class DynamicLinkService {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future handleDynamicLinks() async {
    print('handleDynamicLinks');
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _handleDeepLink(dynamicLinkData, foreground: true);
    }).onError((e) {
      print('Link Failed: ${e.message}');
    });

    print('handleDynamicLinks33');
    return _handleDeepLink(initialLink);
  }

  dynamic _handleDeepLink(PendingDynamicLinkData? data,
      {bool foreground = false}) {
    print('handleDeepLink44444444');
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      var navigationRoute = deepLink.queryParameters['route'];

      var params = deepLink.queryParameters['params'];

      if (navigationRoute != null && params != null) {
        foreground
            ? navigationService.navigateTo(navigationRoute, arguments: params)
            : navigationService.clearStackAndShow(
                navigationRoute,
                arguments: params,
              );
      }
    }

    return deepLink;
  }

  Future<String> createDynamicLink(String route, String params) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://eat24.page.link/',
      link: Uri.parse('https://eat24.page.link/?route=$route&params=$params'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.restaurant_app',
      ),
      // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====

      // TODO: add config for ios
    );

    final Uri dynamicUrl = await dynamicLinks.buildLink(parameters);

    return dynamicUrl.toString();
  }
}
