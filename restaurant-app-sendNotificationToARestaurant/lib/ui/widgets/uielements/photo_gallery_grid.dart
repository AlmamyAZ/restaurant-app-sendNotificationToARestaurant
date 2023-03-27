// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:restaurant_app/core/models/image.dart' as ImageModel;

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/widgets/restaurant/view_models/photo.dart';
import 'package:restaurant_app/ui/widgets/restaurant/views/photo_infos.dart';
import 'cached_network_image.dart';

class GalleryGrid extends StatefulWidget {
  final List<ImageModel.Image> menuImages;
  final bool verticalGallery;
  final Widget skeleton;
  final bool busy;
  final bool editable;

  GalleryGrid({
    required this.menuImages,
    this.verticalGallery = false,
    this.editable = false,
    required this.skeleton,
    required this.busy,
  });

  @override
  _GalleryGridState createState() => _GalleryGridState();
}

class _GalleryGridState extends State<GalleryGrid> {
  @override
  Widget build(BuildContext context) {
    List<GalleryItem> galleryItems = widget.menuImages.map((image) {
      return GalleryItem(
        id: image.id!,
        resource: image.imageUrl!,
        userComment: image.comment!,
        username: image.userName!,
        userProfilePicture: image.userImageProfileUrl!,
        createdAt: image.createdAt!,
        restaurantId: image.restaurantId!,
      );
    }).toList();

    return widget.busy
        ? widget.skeleton
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(
                  galleryItems.length,
                  (idx) => GalleryItemThumbnail(
                        galleryItem: galleryItems[idx],
                        onTap: () {
                          open(context, idx, galleryItems);
                        },
                      )),
            ),
          );
  }

  void open(
    BuildContext context,
    final int index,
    List<GalleryItem> galleryItems,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          editable: widget.editable,
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection:
              widget.verticalGallery ? Axis.vertical : Axis.horizontal,
        ),
      ),
    );
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.editable = false,
    this.maxScale,
    required this.initialIndex,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryItem> galleryItems;
  final Axis scrollDirection;
  final bool editable;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int? currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PhotoInfos(
          username: widget.galleryItems[currentIndex!].username,
          userPhotoProfile:
              widget.galleryItems[currentIndex!].userProfilePicture,
          createdAt: widget.galleryItems[currentIndex!].createdAt,
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
            decoration: widget.backgroundDecoration,
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Stack(
              children: <Widget>[
                PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: _buildItem,
                  itemCount: widget.galleryItems.length,
                  loadingBuilder: widget.loadingBuilder,
                  backgroundDecoration: widget.backgroundDecoration,
                  pageController: widget.pageController,
                  onPageChanged: onPageChanged,
                  scrollDirection: widget.scrollDirection,
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    widget.galleryItems[currentIndex!].userComment,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      decoration: null,
                    ),
                  ),
                )
              ],
            ),
          ),
          widget.editable
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        dynamic response =
                            await locator<PhotoModel>().showBasicBottomSheet(
                          widget.galleryItems[currentIndex!].restaurantId,
                          widget.galleryItems[currentIndex!].id,
                          widget.galleryItems[currentIndex!].resource,
                        );
                        if (response == null) return;
                        navigationService.back();
                      }),
                )
              : Container()
        ],
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final GalleryItem item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.resource),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.id),
    );
  }
}

class GalleryItem {
  GalleryItem({
    required this.id,
    required this.userComment,
    required this.userProfilePicture,
    required this.username,
    required this.resource,
    required this.createdAt,
    required this.restaurantId,
    this.isSvg = false,
  });

  final String id;
  final String resource;
  final String username;
  final String userProfilePicture;
  final DateTime createdAt;
  final String userComment;
  final String restaurantId;
  final bool isSvg;
}

class GalleryItemThumbnail extends StatelessWidget {
  const GalleryItemThumbnail(
      {Key? key, required this.galleryItem, required this.onTap})
      : super(key: key);

  final GalleryItem galleryItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryItem.id,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              child: CachedImageNetwork(
                  image: galleryItem.resource, imageHash: BLURHASH_DEFAULT),
            ),
          ),
        ),
      ),
    );
  }
}
