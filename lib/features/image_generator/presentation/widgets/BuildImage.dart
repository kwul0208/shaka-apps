import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shaka/constants/constants.dart';

Widget buildImage(BuildContext context, String img, double radius) {
    return CachedNetworkImage(
      imageUrl: img,
      progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
        padding: const EdgeInsets.all(appPadding),
        child: Center(child: CupertinoActivityIndicator()),
      ),
      errorWidget: (context, url, error) => Padding(
        padding: const EdgeInsets.all(appPadding),
        child: Center(child: Icon(Icons.error)),
      ),
    );
  }