// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/user_account/settings/settings_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/setting_item.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
        viewModelBuilder: () => SettingsViewModel(),
        onModelReady: (model) {
          model.fetchUserLocalSettings();
        },
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text(
                  'Paramètres',
                  style: Theme.of(context).appBarTheme.toolbarTextStyle,
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // SwitchListTile(
                    //   value: model.notificationEnabled,
                    //   title: Text(
                    //     'Push Notifications',
                    //     style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w500,
                    //         color: Colors.blueGrey),
                    //   ),
                    //   onChanged: (value) =>
                    //       model.changeNotificationState(value),
                    // ),
                    // horizontalSpaceSmall,
                    Divider(),
                    // SettingItem(
                    //   onTap: () {
                    //     navigationService
                    //         .navigateTo(Routes.apparanceModeScreen);
                    //   },
                    //   text: 'Apparence',
                    //   trailingText: 'Mode sombre',
                    // ),
                    SettingItem(
                      onTap: () {
                        navigationService.navigateTo(Routes.aboutScreen);
                      },
                      text: 'A propops',
                      trailingText: '1.0.0',
                    ),
                    verticalSpaceMedium,
                  ],
                ),
              ),
            ));
  }
}
