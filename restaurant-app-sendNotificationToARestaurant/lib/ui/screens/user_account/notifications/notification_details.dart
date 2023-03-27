// Flutter imports:
import 'package:flutter/material.dart';
import 'package:restaurant_app/core/models/notification.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/screens/user_account/notifications/notifications_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';

class NotificationDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OrderNotification notification =
        ModalRoute.of(context)?.settings.arguments as OrderNotification;
    return ViewModelBuilder<NotificationsViewModel>.reactive(
      viewModelBuilder: () => locator<NotificationsViewModel>(),
      onModelReady: (model) {
        if (!notification.isRead) {
          model.readUserNotification(notification.id);
        }
      },
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Notifications',
              style: Theme.of(context).appBarTheme.toolbarTextStyle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                verticalSpaceSmall,
                Text(
                  model.firestoreDateFormat(notification.createdAt),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                verticalSpaceSmall,
                Divider(),
                verticalSpaceSmall,
                Text(
                  notification.content,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
