import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'om_payment_screen_viewmodel.dart';

class OmPaymentScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String url = ModalRoute.of(context)?.settings.arguments as String;

    return ViewModelBuilder<OmPaymentScreenViewModel>.reactive(
        viewModelBuilder: () => OmPaymentScreenViewModel(),
        onModelReady: (model) => model.initializeWebViewController(url),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paiement Orange Money',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            body: model.progressPercent != 100
                ? Center(
                    child: CircularProgressIndicator(
                      value: model.progressPercent / 100,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  )
                : WebViewWidget(controller: model.webViewController),
          );
        });
  }
}
