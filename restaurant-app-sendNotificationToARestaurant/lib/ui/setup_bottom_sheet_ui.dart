// Project imports:
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/bottomSheet/comment_bottom_sheet.dart';
import 'package:restaurant_app/ui/bottomSheet/gallery_bottom_sheet.dart';
import 'package:restaurant_app/ui/bottomSheet/gallery_review_bottom_sheet.dart';
import 'package:restaurant_app/ui/bottomSheet/review_bottom_sheet.dart';

enum BottomSheetType {
  gallery,
  review,
  comment,
  galleryReview,
}

void setupBottomSheetUi() {
  final builders = {
    BottomSheetType.gallery: (context, sheetRequest, completer) =>
        GalleryBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.review: (context, sheetRequest, completer) =>
        ReviewBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.comment: (context, sheetRequest, completer) =>
        CommentBottomSheet(completer: completer, request: sheetRequest),
    BottomSheetType.galleryReview: (context, sheetRequest, completer) =>
        GalleryReviewBottomSheet(completer: completer, request: sheetRequest),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}
