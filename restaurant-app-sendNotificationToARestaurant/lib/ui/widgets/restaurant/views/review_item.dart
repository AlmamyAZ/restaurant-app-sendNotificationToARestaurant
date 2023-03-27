// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:restaurant_app/core/models/review.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/like_view_model.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/review.dart';
import 'package:restaurant_app/ui/widgets/uielements/photo_gallery.dart';

class ReviewItem extends ViewModelWidget<ReviewModel> {
  final bool page;

  final Review review;

  ReviewItem({required this.page, required this.review});

  @override
  Widget build(BuildContext context, ReviewModel model) {
    double commentMaxLines = (review.comment.trim().split(' ').length / 8);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundColor: Colors.grey[100],
            backgroundImage: NetworkImage(review.userImageProfileUrl!),
          ),
          title: Text(review.userName!,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          subtitle: Text(timeago.format(review.createdAt!, locale: 'fr_short')),
          trailing: IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black,
            ),
            onPressed: () async {
              model.showBasicBottomSheet(review);
            },
          ),
        ),
        Row(
          children: [
            RatingBarIndicator(
              rating: review.rating!,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 20.0,
              direction: Axis.horizontal,
            ),
            horizontalSpaceSmall,
            Text(
              review.rating.toString(),
              style: Theme.of(context).textTheme.titleMedium
                ?..copyWith(color: Colors.amber, fontWeight: FontWeight.bold),
            ),
            horizontalSpaceSmall,
          ],
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            if (page) return;
            model.gotoReviewDetail(review);
          },
          child: Text(
            review.comment,
            style: Theme.of(context).textTheme.titleMedium
              ?..copyWith(fontWeight: FontWeight.w500),
            maxLines: !page ? 4 : null,
            overflow: TextOverflow.fade,
          ),
        ),
        SizedBox(height: 10),
        if (commentMaxLines > 4 && !page)
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                page
                    ? FocusScope.of(context).autofocus(FocusNode())
                    : model.gotoReviewDetail(review);
              },
              child: Text(
                'Voir plus',
                style: Theme.of(context).textTheme.titleMedium
                  ?..copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        review.imagesLinks?.length == 0
            ? SizedBox()
            : Gallery(
                editable: model.isEditable(review.userId),
                onClick: (int index) =>
                    model.showReviewPhotoBottomSheet(review, index),
                busy: false,
                skeleton: SizedBox(),
                verticalGallery: false,
                menuImages: review.imagesLinks!,
              ),
        page == false
            ? ReviewSmallFeatures(
                review: review,
                page: page,
              )
            : SizedBox(),
        Divider()
      ],
    );
  }
}

class ReviewSmallFeatures extends ViewModelWidget<ReviewModel> {
  const ReviewSmallFeatures({
    Key? key,
    required this.review,
    required this.page,
  }) : super(key: key);

  final Review review;
  final bool page;

  @override
  Widget build(BuildContext context, ReviewModel reviewmodel) {
    return ViewModelBuilder<StreamLikeViewModel>.reactive(
        viewModelBuilder: () => StreamLikeViewModel(
              reviewId: review.id!,
              commentsCount: review.commentsCount!,
              likesCount: review.likesCounts!,
            ),
        onModelReady: (model) => model.initialiseReviewStats(
              review.likesCounts,
              review.commentsCount,
            ),
        builder: (context, model, child) {
          return Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      page
                          ? FocusScope.of(context).autofocus(FocusNode())
                          : reviewmodel.gotoReviewDetail(review);
                    },
                    child: Text(
                      '${model.likesCount} j\'aimes,',
                      style: Theme.of(context).textTheme.titleMedium
                        ?..copyWith(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                    ),
                  ),
                  horizontalSpaceTiny,
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(0))),
                    onPressed: () {
                      page
                          ? FocusScope.of(context).autofocus(FocusNode())
                          : reviewmodel.gotoReviewDetail(review);
                    },
                    child: Text(
                      '${model.commentsCount} commentaires',
                      style: Theme.of(context).textTheme.titleMedium
                        ?..copyWith(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(0))),
                    onPressed: () {
                      model.likeReview(review, model.isLiked);
                    },
                    icon: Icon(
                      Icons.thumb_up,
                      color: model.isLiked ? primaryColor : Colors.grey,
                      size: 20,
                    ),
                    label: Text(
                      'J\'aime',
                      style: Theme.of(context).textTheme.titleMedium
                        ?..copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  page
                      ? SizedBox()
                      : TextButton.icon(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(0))),
                          onPressed: () {
                            page
                                ? FocusScope.of(context).autofocus(FocusNode())
                                : reviewmodel.gotoReviewDetail(review);
                          },
                          icon: Icon(
                            Icons.comment,
                            color: Colors.grey,
                            size: 20,
                          ),
                          label: Text(
                            'Commenter',
                            style: Theme.of(context).textTheme.titleMedium
                              ?..copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                  horizontalSpaceLarge,
                ],
              ),
            ],
          );
        });
  }
}
