// Package imports:
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/category.dart' as MyCategory;

@singleton // Add decoration
class CategoriesModel extends BaseViewModel {
  List<MyCategory.Category> _categoriesForBundle = [];
  List<MyCategory.Category> get categoriesForBundle => _categoriesForBundle;

  Future fetchCategoriesForBundle(List<String> categoriesId) async {
    print('fetchCategoriesForBundle');
    setBusy(true);
    _categoriesForBundle =
        await categoriesService.getCateriesForBunble(categoriesId);

    setBusy(false);
  }

  @override
  void dispose() {
    print('categories disposed!!');
    super.dispose();
  }
}
