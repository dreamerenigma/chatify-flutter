import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class GifImageWidget extends StatefulWidget {
  final String imageUrl;

  const GifImageWidget({super.key, required this.imageUrl});

  @override
  GifImageWidgetState createState() => GifImageWidgetState();
}

class GifImageWidgetState extends State<GifImageWidget> with SingleTickerProviderStateMixin {
  late GifController gifController;

  @override
  void initState() {
    super.initState();
    gifController = GifController(vsync: this);
    _loadGif();
  }

  Future<void> _loadGif() async {
    try {
      final image = NetworkImage(widget.imageUrl);
      image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) {
          const frameCount = 30;
          gifController.repeat(min: 0, max: frameCount.toDouble(), period: const Duration(seconds: 3));
          setState(() {});
        }),
      );
    } catch (e) {
      log("Error loading GIF: $e");
    }
  }

  @override
  void dispose() {
    gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Gif(controller: gifController, image: NetworkImage(widget.imageUrl));
  }
}
