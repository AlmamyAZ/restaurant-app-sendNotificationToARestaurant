// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/ui/screens/user_account/settings/settings_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/setting_item.dart';

class ApparanceModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
        viewModelBuilder: () => SettingsViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text(
                  'Apparence',
                  style: Theme.of(context).appBarTheme.toolbarTextStyle,
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SettingItem(
                      onTap: () {},
                      id: AppearenceModes.dark,
                      value: model.appearenceMode,
                      hasNext: false,
                      text: 'Dark Mode',
                    ),
                    horizontalSpaceSmall,
                    Divider(),
                    horizontalSpaceSmall,
                    SettingItem(
                      onTap: () {},
                      id: AppearenceModes.light,
                      value: model.appearenceMode,
                      hasNext: false,
                      text: 'Light Mode',
                    ),
                    horizontalSpaceSmall,
                    Divider(),
                    horizontalSpaceSmall,
                    SettingItem(
                      onTap: () {},
                      id: AppearenceModes.system,
                      value: model.appearenceMode,
                      hasNext: false,
                      text: 'Utiliser les options du téléphone',
                    ),
                    verticalSpaceMedium,
                  ],
                ),
              ),
            ));
  }
}
