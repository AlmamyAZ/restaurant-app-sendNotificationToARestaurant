// Package imports:
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/models/notification.dart';
import 'package:restaurant_app/core/services/user_service.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';

@injectable
class NotificationsViewModel extends StreamViewModel {
  bool _editMode = false;
  bool get editMode => _editMode;

  List<OrderNotification> _notifications = [];
  List<OrderNotification> get notifications => _notifications;
  List<String> _unReadNotificationIds = [];

  @override
  Stream<dynamic> get stream =>
      locator<UserService>().orderNotificationStream();

  @override
  void onData(data) {
    List orderNotification = userService.getListOfOrderNotifications(data);
    _notifications = List<OrderNotification>.from(orderNotification);
  }

  Future markAllNotificationAsRead() async {
    _notifications.forEach((notification) {
      if (!notification.isRead) {
        _unReadNotificationIds.add(notification.id);
      }
    });
    await userService.markAllNotificationAsRead(_unReadNotificationIds);
  }

  firestoreDateFormat(date) {
    String formattedDate =
        DateFormat.yMd('fr-FR').add_Hm().format(date.toDate());

    return formattedDate;
  }

  Future<void> readUserNotification(String notificationId) {
    return userService.readNotification(notificationId);
  }

  Future deleteAllNotification(List<OrderNotification> notifications) async {
    final response = await dialogService.showDialog(
      title: "Suppression des notifications",
      description: "La suppression des notification est irreversible",
      cancelTitle: "Annuler",
      cancelTitleColor: Colors.red,
      buttonTitle: "Oui",
    );
    if (!response!.confirmed) {
      return;
    }
    userService.deleteAllNotifications(notifications);
  }

  Future activateEditMode(bool state) async {
    setBusy(true);
    _editMode = state;
    setBusy(false);
  }

  @override
  void dispose() {
    print('view model Account disposed');
    super.dispose();
  }
}
