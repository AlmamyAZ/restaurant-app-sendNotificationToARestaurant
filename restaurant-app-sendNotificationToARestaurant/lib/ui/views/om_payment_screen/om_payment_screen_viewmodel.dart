import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OmPaymentScreenViewModel extends BaseViewModel {
  //webview controller
  late final WebViewController _webViewController;

  int progressPercent = 0;

  // getter for webview controller
  WebViewController get webViewController => _webViewController;

  // initialize webview controller
  void initializeWebViewController(url) {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            progressPercent = progress;
            notifyListeners();
          },
          onPageStarted: (String url) {
            print('page start 😭😭 ::: $url');
          },
          onPageFinished: (String url) {
            print('page finish 😉😉😉 ::: $url');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.compareTo(url) != 0) {
              navigationService.back();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}
