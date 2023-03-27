// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:webview_flutter/webview_flutter.dart';

class GCUView extends StatefulWidget {
  @override
  GCUViewState createState() => GCUViewState();
}

class GCUViewState extends State<GCUView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  late final controller = WebViewController();

  @override
  Widget build(BuildContext context) {
//TODO: add webview
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Condition d\'utilisation',
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          ),
        ),
        body: WebViewWidget(controller: controller)

        //  WebView(
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
