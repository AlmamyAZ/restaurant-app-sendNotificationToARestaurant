// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/models/review.dart';
import 'package:restaurant_app/ui/screens/tabs/restaurant/bottom_tabs_restaurant_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/review.dart';
import 'package:restaurant_app/ui/widgets/restaurant/skeletons/review_item_skeleton.dart';
import 'package:restaurant_app/ui/widgets/uielements/empty_list.dart';
import '../../widgets/restaurant/views/restaurant_presentation.dart';
import '../../widgets/restaurant/views/review_item.dart';

class RestaurantReviewsScreen
    extends ViewModelWidget<BottomTabsRestaurantViewModel> {
  @override
  Widget build(
      BuildContext context, BottomTabsRestaurantViewModel restaurantModel) {
    return Scaffold(
      appBar: buildAppBarFixed(context),
      body: DefaultTabController(
        length: 4,
        child: ViewModelBuilder<ReviewModel>.reactive(
          viewModelBuilder: () => locator<ReviewModel>(),
          onModelReady: (model) {
            if (!restaurantModel.isBusy) {
              model.runInitReviewsFetching(
                  restaurantModel.id!, restaurantModel.restaurant!);
            }
          },
          disposeViewModel: false,
          builder: (context, model, child) => NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                buildSliverToBoxAdapterHeader(
                  context,
                  restaurantModel.id!,
                  restaurantModel.restaurant!.name!,
                  model,
                ),
                buildSliverAppBarCollepse(context, model),
              ];
            },
            body: TabBarView(
              children: [
                buildSliverGridBody(model.allReviews,
                    model.busy(model.allReviews), model, restaurantModel.id!),
                buildSliverGridBody(model.staffReviews,
                    model.busy(model.staffReviews), model, restaurantModel.id!),
                buildSliverGridBody(
                    model.establishmentReviews,
                    model.busy(model.establishmentReviews),
                    model,
                    restaurantModel.id!),
                buildSliverGridBody(model.foodReviews,
                    model.busy(model.foodReviews), model, restaurantModel.id!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding buildSliverGridBody(List<Review> reviews, bool isBusy,
      ReviewModel model, String restaurantId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: RefreshIndicator(
        onRefresh: () {
          return model.releodReview();
        },
        child: (!isBusy && reviews.isEmpty)
            ? EmptyList(
                message: 'Rien à afficher pour le moment',
                sign: Icon(
                  Icons.edit_off,
                  color: Colors.grey[400],
                  size: 150,
                ),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return isBusy
                      ? ReviewItemSkeleton()
                      : ReviewItem(
                          review: reviews[index],
                          page: false,
                        );
                },
                itemCount: isBusy ? 20 : reviews.length,
              ),
      ),
    );
  }

  SliverAppBar buildSliverAppBarCollepse(
      BuildContext context, ReviewModel model) {
    int allReviewsCount = model.reviewsStats == null
        ? 0
        : model.reviewsStats!['total-reviews-count'];
    int staffReviewsCount = model.reviewsStats == null
        ? 0
        : model.reviewsStats!['staff-reviews-count'];
    int establissementReviewsCount = model.reviewsStats == null
        ? 0
        : model.reviewsStats!['establissement-reviews-count'];
    int foodReviewsCount = model.reviewsStats == null
        ? 0
        : model.reviewsStats!['food-reviews-count'];
    Widget _buildChip(String text) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).primaryColor,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline6?.copyWith(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      );
    }

    return SliverAppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      pinned: true,
      title: TabBar(
        isScrollable: true,
        labelPadding: EdgeInsets.symmetric(horizontal: 10),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 4.0,
        indicatorPadding: EdgeInsets.all(0),
        tabs: [
          Tab(
            child: _buildChip('Tous ($allReviewsCount)'),
          ),
          Tab(
            child: _buildChip('Personel ($staffReviewsCount)'),
          ),
          Tab(
            child: _buildChip('Etablissement ($establissementReviewsCount)'),
          ),
          Tab(
            child: _buildChip('Nourriture ($foodReviewsCount)'),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter buildSliverToBoxAdapterHeader(BuildContext context,
      String restaurantId, String name, ReviewModel model) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RestaurantPresentation(),
            verticalSpaceTiny,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Avis',
                  style: Theme.of(context).appBarTheme.toolbarTextStyle,
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(5),
                          top: Radius.circular(5),
                        ),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () async {
                    Map? result =
                        await model.pushToAddReview(restaurantId, name);

                    if (result == null) return;

                    if (result['refreshData']) model.releodReview();
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Ecrire un avis',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            verticalSpaceTiny
          ],
        ),
      ),
    );
  }

  AppBar buildAppBarFixed(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        'Avis',
        style: Theme.of(context).appBarTheme.toolbarTextStyle,
      ),
    );
  }
}
