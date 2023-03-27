// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

// Project imports:
import 'package:restaurant_app/constants.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/cached_network_image.dart';

class Gallery extends StatefulWidget {
  final List<String> menuImages;
  final bool verticalGallery;
  final Widget skeleton;
  final bool busy;
  final bool editable;
  final Function(int)? onClick;

  Gallery({
    required this.menuImages,
    this.verticalGallery = false,
    this.editable = false,
    this.onClick,
    required this.skeleton,
    required this.busy,
  });

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    List<GalleryItem> galleryItems = widget.menuImages
        .map(
          (imageUrl) => GalleryItem(
            id: imageUrl,
            resource: imageUrl,
          ),
        )
        .toList();

    return Container(
      height: 70,
      child: ListView.separated(
        separatorBuilder: (ctx, idx) => horizontalSpaceTiny,
        scrollDirection: Axis.horizontal,
        itemCount: widget.busy ? 4 : galleryItems.length,
        itemBuilder: (ctx, idx) => Container(
          height: 70,
          width: 70,
          child: widget.busy
              ? widget.skeleton
              : GalleryItemThumbnail(
                  galleryItem: galleryItems[idx],
                  onTap: () {
                    open(context, idx, galleryItems);
                  },
                ),
        ),
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
          galleryItems: galleryItems,
          editable: widget.editable,
          onClick: widget.onClick!,
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
    required this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    required this.initialIndex,
    this.editable = false,
    required this.onClick,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryItem> galleryItems;
  final Axis scrollDirection;
  final bool editable;
  final Function onClick;

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
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
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
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Image ${currentIndex! + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    decoration: null,
                  ),
                ),
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
                          dynamic response = await widget.onClick(currentIndex);

                          if (response == null) return;
                          navigationService.back();
                        }),
                  )
                : Container()
          ],
        ),
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
  GalleryItem({required this.id, required this.resource, this.isSvg = false});

  final String id;
  final String resource;
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
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryItem.id,
          child: Container(
            height: 80.0,
            width: 80.0,
            child: CachedImageNetwork(
                image: galleryItem.resource, imageHash: BLURHASH_DEFAULT),
          ),
        ),
      ),
    );
  }
}
