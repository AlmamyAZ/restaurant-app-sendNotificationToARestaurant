// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

class PolicyView extends StatefulWidget {
  @override
  PolicyViewState createState() => PolicyViewState();
}

class PolicyViewState extends State<PolicyView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    // if (Platform.isAndroid) WebViewController.platform = SurfaceAndroidWebView();
  }

  late final controller = WebViewController();

//TODO: add webview

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Politique de confidentialité',
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          ),
        ),
        body: WebViewWidget(controller: controller)
//TODO: add webview
        // WebViewWidget(
        //   initialUrl: arguments,
        //   onProgress: (int progress) => Center(
        //     child: CircularProgressIndicator(
        //       backgroundColor: primaryColor,
        //       value: progress.toDouble(),
        //     ),
        //   ),
        // ),
        );
  }
}
