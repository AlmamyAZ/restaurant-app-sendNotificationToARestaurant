// Flutter imports:
import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/widgets/uielements/searchbarMenu.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/collection.dart';
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/shared/validators.dart';
import 'package:restaurant_app/ui/widgets/collection/view_models/collections.dart';
import 'package:restaurant_app/ui/widgets/collection/views/collection_icon.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';
import 'package:restaurant_app/ui/widgets/uielements/primary_button.dart';
import '../../widgets/restaurant/views/restaurant_description.dart';
import '../../widgets/restaurant/views/restaurant_header.dart';
import '../../widgets/restaurant/views/restaurant_presentation.dart';
import '../../widgets/restaurant/views/sliver_restaurants_list.dart';
import '../../widgets/restaurant/views/sponsored_restaurants_grid.dart';
import '../../widgets/uielements/section_title.dart';

class RestaurantDetailsScreen
    extends ViewModelWidget<BottomTabsRestaurantViewModel> {
  static const String routeName = '/restaurant-details';

  final Map<String, dynamic> restaurant;

  RestaurantDetailsScreen({required this.restaurant});

  @override
  Widget build(BuildContext context, BottomTabsRestaurantViewModel model) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              restaurant['name'],
              style: Theme.of(context).appBarTheme.toolbarTextStyle,
            ),
            actions: [
              IconButton(
                icon: CollectionIcon(
                  restaurantId: model.id!,
                ),
                onPressed: () async {
                  try {
                    await authenticationService.redirectIfNotConneted();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogAddToCollection(
                          restaurantId: model.id!,
                        );
                      },
                    );
                  } catch (e) {}
                },
              ),
              IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    model.share();
                  }),
              SearchBarMenu(
                restaurantId: model.id!,
              )
            ],
            flexibleSpace: RestaurantHeader(restaurant: restaurant),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            expandedHeight: 250,
            elevation: 0,
            pinned: true,
            toolbarTextStyle: TextTheme(
              headline6: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ).bodyText2,
            titleTextStyle: TextTheme(
              headline6: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ).headline6,
          ),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  RestaurantPresentation(),
                  RestaurantActions(),
                  RestaurantDescription(),
                  Divider(),
                  verticalSpaceSmall,
                  SectionTitle(title: 'Restaurants Sponsorts')
                ],
              ),
            ),
          ),
          SponsoredRestaurantsGrid(),
          SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  verticalSpaceSmall,
                  SectionTitle(title: 'Restaurants Similaires'),
                ],
              ),
            ),
          ),
          SliverRelatedRestaurantsList()
        ],
      ),
    );
  }
}

class RestaurantActions extends ViewModelWidget<BottomTabsRestaurantViewModel> {
  Widget _buildAction(BuildContext context, BottomTabsRestaurantViewModel model,
      String restaurantId, IconData icon, String title, String type) {
    return InkWell(
      onTap: () async {
        switch (type) {
          case "rate":
            {
              model.pushToAddReview(model.id, model.restaurant!.name!);
            }
            break;
          case "image":
            {
              try {
                await authenticationService.redirectIfNotConneted();
                model.pickPicture(model.id!);
              } catch (e) {}
            }
            break;
          case "share":
            {
              model.share();
            }
            break;

          case "collection":
            {
              try {
                await authenticationService.redirectIfNotConneted();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogAddToCollection(
                      restaurantId: model.id!,
                    );
                  },
                );
              } catch (e) {}
            }
            break;
          default:
            {}
            break;
        }
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 25,
            color: Colors.white,
          ),
          verticalSpaceTiny,
          Text(
            title,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, BottomTabsRestaurantViewModel model) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAction(
              context, model, model.id!, Icons.star_half, 'Noter', 'rate'),
          _buildAction(
              context, model, model.id!, Icons.add_a_photo, 'Photo', 'image'),
          _buildAction(context, model, model.id!, Icons.bookmark_border,
              'Collectionner', 'collection'),
          _buildAction(
              context, model, model.id!, Icons.share, 'Partager', 'share'),
        ],
      ),
    );
  }
}

class DialogAddToCollection extends StatelessWidget {
  final String restaurantId;
  const DialogAddToCollection({
    required this.restaurantId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CollectionModel>.reactive(
      viewModelBuilder: () => locator<CollectionModel>(),
      disposeViewModel: false,
      builder: (context, model, child) => AlertDialog(
        title: Text(
          'Ajouter à la collection ',
          style: TextStyle(fontSize: 22),
        ),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: 230,
          child: ListView.builder(
            itemCount: model.userCollections.length,
            itemBuilder: (BuildContext context, index) {
              Collection collection = model.userCollections[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            collection.title!,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          verticalSpaceSmall,
                          Text(collection.restaurantIds!.length.toString()),
                        ],
                      ),
                      Checkbox(
                          value: model.isThisRestaurantInside(
                            collection.restaurantIds!,
                            restaurantId,
                          ),
                          onChanged: (bool? isAdding) {
                            model.addOrRemoveRestaurandsToCollection(
                              collection.id!,
                              restaurantId,
                              isAdding!,
                            );
                          })
                    ],
                  ),
                  verticalSpaceSmall
                ],
              );
            },
          ),
        ),
        actions: [
          PrimaryButton(
            textColor: Colors.white,
            title: "Fermer",
            onPress: () => Navigator.pop(context),
          ),
          PrimaryButton(
            textColor: Colors.white,
            title: "Nouvelle collection",
            onPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogCreateNewCollection();
                },
              );
            },
          )
        ],
      ),
    );
  }
}

class DialogCreateNewCollection extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  DialogCreateNewCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final collectionName = TextEditingController();
    return ViewModelBuilder<CollectionModel>.nonReactive(
      viewModelBuilder: () => locator<CollectionModel>(),
      builder: (context, model, child) => AlertDialog(
        title: Text(
          'Nouvelle collection',
          style: TextStyle(fontSize: 18),
        ),
        content: Container(
          width: screenWidth(context),
          height: 100,
          child: Form(
            key: _formKey,
            child: Container(
              child: InputField(
                controller: collectionName,
                validator: codeValidator,
                placeholder: 'Nommez votre collection',
              ),
            ),
          ),
        ),
        actions: [
          PrimaryButton(
            textColor: Colors.white,
            title: "Annuler",
            onPress: () => Navigator.pop(context),
          ),
          PrimaryButton(
            textColor: Colors.white,
            title: "Créer",
            onPress: () async {
              if (_formKey.currentState!.validate()) {
                await model.addUserCollection(true);
              }
            },
          )
        ],
      ),
    );
  }
}
