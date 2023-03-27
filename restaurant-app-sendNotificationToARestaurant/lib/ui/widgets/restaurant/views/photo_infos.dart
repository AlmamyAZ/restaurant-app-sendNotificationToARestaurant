// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:timeago/timeago.dart' as timeago;

class PhotoInfos extends StatelessWidget {
  final bool page;
  final String username;
  final String userPhotoProfile;
  final DateTime createdAt;

  PhotoInfos(
      { this.page = false,
      required this.userPhotoProfile,
      required this.username,
      required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(userPhotoProfile),
            backgroundColor: Colors.grey[100],
          ),
          title: Text(username,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
          subtitle: Text(
            timeago.format(createdAt, locale: 'fr_short'),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
