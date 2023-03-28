// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:restaurant_app/core/models/adress.dart';
import 'package:restaurant_app/core/models/order.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';

extension on DateTime {
  DateTime roundDown({Duration delta = const Duration(minutes: 5)}) {
    return DateTime.fromMillisecondsSinceEpoch(this.millisecondsSinceEpoch -
        this.millisecondsSinceEpoch % delta.inMilliseconds);
  }
}

void pushWithPopRestartRestaurantId(
    String id,
    String name,
    String imageUrl,
    String imageHash,
    List<Map<String, dynamic>> openHours,
    String phoneNumber) async {
  await navigationService.navigateTo(Routes.bottomTabsRestaurant, arguments: {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'imageHash': imageHash,
    'openHours': openHours,
    'phoneNumber': phoneNumber,
  });
}

bool isOpen(List<Map<String, dynamic>> weekHours) {
  Map<String, dynamic> todayHours = getDayHours(weekHours);

  if (todayHours['isClose'] == true) return false;

  if (todayHours['is24OpenDay'] == true) return true;
  List<String> openHoursDay = getListofDayHours(weekHours);

  if (openHoursDay.length == 1) {
    return openHoursDay[0] == "Fermé" ? false : true;
  }
  Map<String, double> keyTimes = getKeyTimesOfDayInDouble(openHoursDay);

  return isNowOpen(keyTimes);
}

List<Map<String, dynamic>> generateDeliveryHours(
  List<Map<String, dynamic>> openHours, {
  bool? today,
}) {
  int day = getDay(today!);
  List<String> openHoursDay = getListofDayHours(openHours, day: day);
  Map<String, DateTime> keyTimesForDelivery =
      getKeyTimesForDelivery(openHoursDay, today);
  List<Map<String, dynamic>> deliveryHours = [];

  DateTime startTime = keyTimesForDelivery['startTime']!;
  DateTime endTime = keyTimesForDelivery['endTime']!;

  while (startTime.isBefore(endTime)) {
    deliveryHours.add({
      'value': startTime.toString(),
      'label': formatDeliveryTimeFrame(startTime),
    });

    startTime = startTime.add(Duration(minutes: 30));
  }

  if (deliveryHours.isNotEmpty) {
    deliveryHours.removeLast();
  } else {
    deliveryHours.add({
      'value': 'Pas d\'horaire de livraison pour ce jour',
      'label': 'Pas d\'horaire de livraison pour ce jour',
      'enable': false
    });
  }

  return deliveryHours;
}

String formatDeliveryTimeFrame(DateTime now) =>
    '${DateFormat('kk:mm').format(now)} - ${DateFormat('kk:mm').format(now.add(Duration(minutes: 30)))}';

bool isBeforeTime(DateTime now, DateTime closeHourDate) {
  return toDouble(TimeOfDay.fromDateTime(now)) <
      toDouble(TimeOfDay.fromDateTime(closeHourDate));
}

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

int getDay(bool today) {
  int day = 0;
  if (today) day = 1;
  return day;
}

List<String> getListofDayHours(List<Map<String, dynamic>> openHours,
    {int day = 1}) {
  List<String> openHoursDay = openHours
      .elementAt(DateTime.now().weekday - day)['hours']
      .toString()
      .split('-');

  return openHoursDay;
}

Map<String, dynamic> getDayHours(List<Map<String, dynamic>> openHours,
    {int day = 1}) {
  return openHours.elementAt(DateTime.now().weekday - day);
}

Future launchMap(GeoPoint position) async {
  final availableMaps = await MapLauncher.installedMaps;
  availableMaps.first.showDirections(
      extraParams: {'zoom': '20'},
      destination: Coords(position.latitude, position.longitude));
}

bool isNowOpen(Map<String, double> keyTimes) {
  if (keyTimes['closeTime']! < keyTimes['openTime']!) {
    keyTimes['closeTime'] = keyTimes['closeTime']! + 24.0;
  }

  return keyTimes['openTime']! < keyTimes['nowTime']! &&
      keyTimes['closeTime']! > keyTimes['nowTime']!;
}

DateTime parseStringToTime(String openHoursDay) {
  DateTime openHourDate = DateFormat('HH:mm').parse(openHoursDay);
  return openHourDate;
}

Map<String, double> getKeyTimesOfDayInDouble(List<String> openHoursDay) {
  DateTime openHourDate = parseStringToTime(openHoursDay[0]);
  DateTime closeHourDate = parseStringToTime(openHoursDay[1]);
  DateTime now = new DateTime.now();

  return {
    'openTime': toDouble(TimeOfDay.fromDateTime(openHourDate)),
    'closeTime': toDouble(TimeOfDay.fromDateTime(closeHourDate)),
    'nowTime': toDouble(TimeOfDay.fromDateTime(now)),
  };
}

Map<String, DateTime> getKeyTimesForDelivery(
  List<String> openHoursDay,
  bool isToday,
) {
  DateTime now = new DateTime.now().toUtc();
  List<String> openHour = openHoursDay[0].split(':');
  DateTime openHourDate = new DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(openHour[0]),
    int.parse(openHour[1]),
  );

  List<String> closeHour = openHoursDay[1].split(':');

  int openHourOnly = int.parse(openHour[0]);
  int closeHourOnly = int.parse(closeHour[0]);

  DateTime closeHourDate = closeHourOnly < openHourOnly
      ? new DateTime(
          now.year,
          now.month,
          now.day + 1,
          int.parse(closeHour[0]),
          int.parse(closeHour[1]),
        )
      : new DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(closeHour[0]),
          int.parse(closeHour[1]),
        );

  if (isBeforeTime(now, openHourDate)) {
    now = openHourDate.add(Duration(hours: 1)).roundDown();
  } else {
    now = new DateTime.now().add(Duration(hours: 1)).roundDown();
  }

  openHourDate = isToday ? now : openHourDate;
  return {
    'startTime': openHourDate,
    'endTime': closeHourDate,
  };
}

String flattenMapToString(List<Map<String, dynamic>> kitchenSpeciality) {
  List names = kitchenSpeciality.map((e) => e['name']).toList();
  return names.join(', ');
}

Map<String, dynamic> convertAdressToJson(Adress adress) {
  Map adressData = adress.toJson();

  adressData['latLng'] =
      mapService.convertCoordinatesToGeoFire(adress.latLng!).data;

  adressData.removeWhere((key, value) => value == null);
  return adressData as Map<String, dynamic>;
}

String generateColorForCollection() {
  List colors = [
    Colors.grey,
    Colors.purple,
    Colors.orange,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.pink,
    Colors.teal,
  ];

  int index = Random().nextInt(colors.length);
  Color color = colors[index] as Color;
  return color.value.toRadixString(16);
}

String formatCurrency(double? price) {
  return NumberFormat.currency(
          locale: 'fr_FR',
          name: 'GNF',
          symbol: 'GNF',
          customPattern: '###,### \u00a4')
      .format(price != null ? price : 0.0);
}

Map<String, dynamic>? formatOrderStatus(OrderStatus status) {
  switch (status) {
    case OrderStatus.canceledByUser:
      return {'label': 'Commande annulée', 'color': Colors.redAccent};
    case OrderStatus.waitingRestaurantConfirmation:
      return {
        'label': 'En attente de confirmation',
        'color': Colors.orangeAccent
      };
    case OrderStatus.rejectedByRestaurant:
      return {'label': 'Rejetée par le restaurant', 'color': Colors.redAccent};
    case OrderStatus.completed:
      return {'label': 'Commande terminée', 'color': Colors.greenAccent};
    case OrderStatus.processingByRestaurant:
      return {'label': 'En cours de préparation', 'color': Colors.orangeAccent};
    case OrderStatus.delivering:
      return {'label': 'En cours de livraison', 'color': Colors.orangeAccent};
    case OrderStatus.waitingForPickup:
      return {'label': 'Prête pour récupération', 'color': Colors.orangeAccent};
  }
}

LatLng computeCentroid(Iterable<LatLng> points) {
  double latitude = 0;
  double longitude = 0;
  int n = points.length;

  for (LatLng point in points) {
    latitude += point.latitude;
    longitude += point.longitude;
  }

  return LatLng(latitude / n, longitude / n);
}
