import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PicturePage extends StatelessWidget {
  final String picture;
  const PicturePage({super.key, required this.picture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: PhotoView(
          imageProvider: CachedNetworkImageProvider(picture),
          backgroundDecoration: BoxDecoration(color: Theme.of(context).canvasColor),
        ));
  }
}
