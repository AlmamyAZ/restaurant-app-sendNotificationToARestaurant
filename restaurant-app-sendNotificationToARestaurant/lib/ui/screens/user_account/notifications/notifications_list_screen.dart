// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';
import 'package:restaurant_app/core/models/notification.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/user_account/notifications/notifications_view_model.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/empty_list.dart';
import 'package:restaurant_app/ui/widgets/uielements/primary_button.dart';

class NotificationListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationsViewModel>.reactive(
        viewModelBuilder: () => locator<NotificationsViewModel>(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Notifications',
                style: Theme.of(context).appBarTheme.toolbarTextStyle,
              ),
              actions: model.notifications.length == 0
                  ? []
                  : [
                      if (!model.editMode)
                        IconButton(
                            icon: Icon(Icons.edit_outlined),
                            onPressed: () async {
                              model.activateEditMode(true);
                            }),
                      if (model.editMode)
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () async {
                              model.activateEditMode(false);
                            }),
                    ],
            ),
            bottomNavigationBar: model.editMode
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PrimaryButton(
                        color: Colors.grey[300]!,
                        textColor: Colors.black,
                        onPress: model.markAllNotificationAsRead,
                        title: 'Tous marquer comme lu',
                      ),
                      PrimaryButton(
                        onPress: () {
                          model.deleteAllNotification(model.notifications);
                        },
                        title: 'Tous effacer',
                      ),
                    ],
                  )
                : null,
            body: !model.busy(model.notifications) &&
                    model.notifications.length == 0
                ? EmptyList(
                    sign: Icon(
                      Icons.notifications_off_outlined,
                      color: Colors.grey[400],
                      size: 150,
                    ),
                    message: 'Rien à afficher pour le moment',
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: model.notifications.length,
                    itemBuilder: (ctx, idx) {
                      return model.busy(model.notifications)
                          ? NotificationSkeletonCard()
                          : ListTile(
                              leading: Icon(
                                Icons.mail_outline,
                                color: primaryColor,
                              ),
                              title: Text(
                                model.notifications[idx].title,
                                style: TextStyle(
                                    color: model.notifications[idx].isRead
                                        ? null
                                        : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.notifications[idx].content,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  verticalSpaceSmall,
                                  Text(
                                    model.firestoreDateFormat(
                                      model.notifications[idx].createdAt,
                                    ),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  verticalSpaceMedium,
                                ],
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Colors.grey,
                              ),
                              onTap: () async {
                                await navigationService.navigateTo(
                                  Routes.notificationDetails,
                                  arguments: model.notifications[idx],
                                );
                              },
                            );
                    },
                  ),
          );
        });
  }
}

class NotificationSkeletonCard extends StatelessWidget {
  const NotificationSkeletonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentPlaceholder(
      spacing: EdgeInsets.all(10),
      height: double.infinity,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        // height: 100,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentPlaceholder.block(
                  width: MediaQuery.of(context).size.width * 0.6, height: 10),
              ContentPlaceholder.block(
                  width: MediaQuery.of(context).size.width * 0.8, height: 7),
              ContentPlaceholder.block(
                  width: MediaQuery.of(context).size.width * 0.7, height: 7),
              verticalSpaceMedium,
              ContentPlaceholder.block(
                  width: MediaQuery.of(context).size.width * 0.2, height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyNotificationList extends StatelessWidget {
  const EmptyNotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: screenHeight(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            color: Colors.grey[400],
            size: 50,
          ),
          verticalSpaceSmall,
          Text('Rien à afficher pour le moment',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey[400])),
        ],
      ),
    );
  }
}
