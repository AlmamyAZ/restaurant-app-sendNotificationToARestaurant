// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:content_placeholder/content_placeholder.dart';
import 'package:stacked/stacked.dart';
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:restaurant_app/core/models/review.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/comment_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/review.dart';
import 'package:restaurant_app/ui/widgets/uielements/input_field.dart';
import '../../widgets/restaurant/views/review_item.dart';

class ReviewDisplayScreen extends StatefulWidget {
  static const String routeName = 'review-display';
  @override
  _ReviewDisplayScreenState createState() => _ReviewDisplayScreenState();
}

class _ReviewDisplayScreenState extends State<ReviewDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    Review review = ModalRoute.of(context)?.settings.arguments as Review;
    return ViewModelBuilder<CommentViewModel>.reactive(
      viewModelBuilder: () => CommentViewModel(
        restaurantId: review.restaurantId!,
        reviewId: review.id!,
      ),
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildAppBarFixed(),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  buildSliverToBoxAdapterHeader(),
                  buildSliverGridBody(model),
                  SliverToBoxAdapter(child: verticalSpaceMedium),
                ],
              ),
              model.isEditing
                  ? GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        model.cancelEditing();
                      },
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              curve: Curves.slowMiddle,
              height: MediaQuery.of(context).viewInsets.bottom + 70,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: InputField(
                    fieldFocusNode: model.commentFocusNode,
                    suffix: model.isEditing ? 'Sauver' : 'Poster',
                    suffixFunction: () {
                      if (model.commentControler.text.trim() == '') return;

                      model.addOrEditRespondReview(review);
                    },
                    textInputType: TextInputType.text,
                    controller: model.commentControler,
                    placeholder: 'Commentaire',
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  SliverPadding buildSliverGridBody(CommentViewModel model) {
    return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return !model.dataReady
                  ? ReviewItemSkeleton()
                  : InkWell(
                      onLongPress: () {
                        model.showBasicBottomSheet(
                            model.respondReviews![index], context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, bottom: 20, top: 0),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            backgroundImage: NetworkImage(
                              model.respondReviews![index].userImageProfileUrl!,
                            ),
                          ),
                          title: Text(model.respondReviews![index].userName!,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              verticalSpaceTiny,
                              Text(
                                model.respondReviews![index].comment,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              verticalSpaceSmall,
                              Text(
                                timeago.format(
                                    model.respondReviews![index].createdAt!,
                                    locale: 'fr_short'),
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            },
            childCount: !model.dataReady ? 1 : model.respondReviews?.length,
          ),
        ));
  }

  SliverToBoxAdapter buildSliverToBoxAdapterHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: ViewModelBuilder<ReviewModel>.reactive(
          builder: (context, model, child) => ReviewItem(
            review: ModalRoute.of(context)?.settings.arguments as Review,
            page: true,
          ),
          viewModelBuilder: () => ReviewModel(),
          disposeViewModel: false,
        ),
      ),
    );
  }

  AppBar buildAppBarFixed() {
    return AppBar(
      elevation: 0,
      title: Text(
        'Avis',
        style: Theme.of(context).appBarTheme.toolbarTextStyle,
      ),
    );
  }
}

class ReviewItemSkeleton extends StatelessWidget {
  const ReviewItemSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 215;
    return ContentPlaceholder(
      width: width,
      spacing: EdgeInsets.all(10),
      height: double.infinity,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: new BoxDecoration(
                      color: Color(0xFFf1f3f4),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  horizontalSpaceTiny,
                  ContentPlaceholder.block(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 10),
                ],
              ),
              ContentPlaceholder.block(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 12,
                  topSpacing: 10),
              ContentPlaceholder.block(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 12,
              ),
              ContentPlaceholder.block(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 12,
                  bottomSpacing: 0),
            ],
          )),
    );
  }
}
