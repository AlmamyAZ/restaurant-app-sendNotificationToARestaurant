// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:octo_image/octo_image.dart';

class CachedImageNetwork extends StatelessWidget {
  final String image;
  final String imageHash;

  const CachedImageNetwork({
    Key? key,
    required this.image,
    required this.imageHash,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: OctoImage(
        image: CachedNetworkImageProvider(image),
        placeholderBuilder: OctoPlaceholder.blurHash(imageHash),
        errorBuilder: OctoError.icon(color: Colors.red),
        fit: BoxFit.cover,
      ),
    );
  }
}
