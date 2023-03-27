import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:restaurant_app/core/models/menu.dart';
import 'package:restaurant_app/core/models/restaurant.dart';

@singleton
class AlgoliaService {
  Algolia algolia = Algolia.init(
    applicationId: 'AQDHJ9CXSI',
    apiKey: '291005c5cfffa8021a7a8603a4d43f10',
  );

  Future<List<Restaurant>> searchRestaurants(String query) async {
    AlgoliaQuery algoliaQuery =
        algolia.instance.index('restaurants').query(query);
    AlgoliaQuerySnapshot snapshot = await algoliaQuery.getObjects();
    final rawHits = snapshot.toMap()['hits'] as List;

    return serializeRestaurants(rawHits);
  }

  Future<List<MenuItem>> searchItems(String query, String restaurantId) async {
    AlgoliaQuery algoliaQuery = algolia.instance
        .index('items')
        .query(query)
        .facetFilter('restaurantId:$restaurantId');

    AlgoliaQuerySnapshot snapshot = await algoliaQuery.getObjects();
    final rawHits = snapshot.toMap()['hits'] as List;

    return rawHits.map((item) {
      item['id'] = item['objectID'];
      item['sectionId'] = item['sectionsIds'][0];
      return MenuItem.fromJson(item);
    }).toList();
  }

  List<Restaurant> serializeRestaurants(List<dynamic> hits) {
     return hits
        .map((data) {
          return serializeRestaurant(
              data as Map<String, dynamic>, data["objectID"]);
        })
        .where((mappedItem) => mappedItem.name != null)
        .toList();
  }

  Restaurant serializeRestaurant(Map<String, dynamic> data, restaurantId) {
    try {
      data['createdAt'] = data['createdAt']?.toDate();
      data['installation'] = getInstallation(data['installations']);
      data['dishDay'] = listMapToListString(data['dishDay']);

      String zone = data['adress']['zone'];
      String quartier = data['adress']['quartier'];
      String description = data['adress']['description'];

      data['fullAdress'] = '$zone, $quartier, $description';

      Map<String, dynamic> latLng = data['adress']['position']['_geoloc'];

      data['position'] = GeoPoint(latLng['lat'], latLng['lng']);

      Restaurant restaurant = Restaurant.fromJson(data, restaurantId);
      return restaurant;
    } catch (e) {
      print('🤬🤬🤬🤬🤬:: $e ');
      return Restaurant();
    }
  }
}

String getInstallation(List<dynamic> data) {
  return listMapToListString(data).join(' ');
}

List<String> listMapToListString(List<dynamic> data,
    {String property = 'name'}) {
  return data.map((element) => element[property] as String).toList();
}
