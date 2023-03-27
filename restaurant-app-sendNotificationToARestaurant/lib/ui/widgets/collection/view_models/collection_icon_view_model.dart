// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';

@injectable
class CollectionIconViewModel extends StreamViewModel {
  final String? localRestaurantId;

  CollectionIconViewModel({ this.localRestaurantId});

  bool _value = false;
  bool get value => _value;

  User get user => data;

  Stream get stream =>
      collectionService.restaurantCollectionned(localRestaurantId!);

  @override
  void onData(data) {
    _value = data.size == 1;
  }

  @override
  void dispose() {
    print('collections disposed!!');
    super.dispose();
  }
}
