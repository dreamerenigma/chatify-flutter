import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import 'message_meta.dart';

class StickerMessage extends StatefulWidget {
  final String imageUrl;
  final dynamic message;

  const StickerMessage({
    super.key,
    required this.imageUrl,
    required this.message,
  });

  @override
  State<StickerMessage> createState() => _StickerMessageState();
}

class _StickerMessageState extends State<StickerMessage> {
  String? stickerUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSticker();
  }

  Future<void> _loadSticker() async {
    try {
      final url = await APIs.getMediaUrl(widget.imageUrl);

      if (!mounted) return;

      setState(() {
        stickerUrl = url;
        isLoading = false;
      });
    } catch (e, st) {
      log('[STICKER] Failed to get URL: $e');
      log('$st');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          const SizedBox(
            width: 200,
            height: 200,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (stickerUrl != null && stickerUrl!.isNotEmpty)
          Image.network(
            stickerUrl!,
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              log('[STICKER] Image load failed: $error');

              return const SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: Icon(Icons.broken_image_outlined),
                ),
              );
            },
          )
        else
          const SizedBox(
            width: 200,
            height: 200,
            child: Center(
              child: Icon(Icons.broken_image_outlined),
            ),
          ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageLight, borderRadius: BorderRadius.circular(25)),
            child: MessageMeta(message: widget.message, isWebOrWindows: Platform.isWindows, showCheck: true, isSender: false, fitContent: true),
          ),
        ),
      ],
    );
  }
}
