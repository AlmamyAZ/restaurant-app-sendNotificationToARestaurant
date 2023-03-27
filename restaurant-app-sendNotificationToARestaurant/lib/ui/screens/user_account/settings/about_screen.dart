// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_app/ui/widgets/uielements/busy_overlay.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/user_account/settings/settings_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/dashboard_item.dart';
import 'package:restaurant_app/ui/widgets/uielements/small_logo.dart';
import 'package:restaurant_app/ui/widgets/uielements/text_link.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
        viewModelBuilder: () => SettingsViewModel(),
        onModelReady: (model) {
          model.getAboutSettings();
        },
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              body: BusyOverlay(
                show: model.isBusy,
                title: 'Chargement en cours',
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        verticalSpaceLarge,
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedLogo(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  model.isBusy ? '' : 'v ${model.version}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                '${DateTime.now().year} ' +
                                    (model.isBusy
                                        ? ''
                                        : '${model.aboutSettings!['appName'] ?? 'Eat224'}.'),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                model.isBusy
                                    ? ''
                                    : '${model.aboutSettings!['madeIn'] ?? 'Fait en Guinée.'}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                        horizontalSpaceSmall,
                        Divider(),
                        horizontalSpaceSmall,
                        DashboardItem(
                          onTap: () {
                            model.launchFacebookPage();
                          },
                          text: 'Nous suivre sur Facebook',
                          icon: FontAwesomeIcons.facebookF,
                        ),
                        DashboardItem(
                          onTap: () {
                            model.launchInstagram();
                          },
                          text: 'Nous suivre sur Instagram',
                          icon: FontAwesomeIcons.instagram,
                        ),
                        // DashboardItem(
                        //   onTap: () {},
                        //   text: 'Nous noter sur playstore',
                        //   icon: FontAwesomeIcons.googlePlay,
                        // ),
                        horizontalSpaceSmall,
                        Divider(),
                        horizontalSpaceSmall,
                        // DashboardItem(
                        //   onTap: () {},
                        //   text: 'Un probleme de commande ?',
                        //   icon: Icons.delivery_dining,
                        // ),
                        // DashboardItem(
                        //     onTap: () {},
                        //     text: 'Nous laisser un feedback',
                        //     icon: Icons.feedback_outlined),
                        Divider(),
                        verticalSpaceMedium,
                        TextLink('Conditions d\'utilisations',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: primaryColor,
                            ), onPressed: () {
                          navigationService.navigateTo(Routes.gCUView,
                              arguments: model.aboutSettings!['cguLink']);
                        }),
                        verticalSpaceMedium,
                        verticalSpaceSmall,
                        TextLink(
                          'Politiques de confidentialitées',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: primaryColor,
                          ),
                          onPressed: () {
                            navigationService.navigateTo(Routes.policyView,
                                arguments:
                                    model.aboutSettings!['confidentials']);
                          },
                        ),
                        verticalSpaceMedium,
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
