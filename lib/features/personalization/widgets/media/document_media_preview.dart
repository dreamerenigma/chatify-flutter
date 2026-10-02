import 'dart:typed_data';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:pdfx/pdfx.dart';
import '../../../../api/apis.dart';
import '../../../../utils/constants/app_colors.dart';
import '../dialogs/light_dialog.dart';
import '../items/chat_media_item.dart';

class DocumentMediaPreview extends StatefulWidget {
  final ChatMediaItem media;
  final double borderRadius;

  const DocumentMediaPreview({
    super.key,
    required this.media,
    this.borderRadius = 8,
  });

  @override
  State<DocumentMediaPreview> createState() => _DocumentMediaPreviewState();
}

class _DocumentMediaPreviewState extends State<DocumentMediaPreview> {
  Future<Uint8List?>? _previewFuture;

  @override
  void initState() {
    super.initState();

    _previewFuture = _loadPreview();
  }

  Future<Uint8List?> _loadPreview() async {
    try {
      final url = await APIs.getMediaUrl(widget.media.path);

      if (url == null || url.isEmpty) {
        throw Exception('Document URL is empty');
      }

      log('DOCUMENT MEDIA PREVIEW: $url');

      final response = await Dio().get<List<int>>(url, options: Options(responseType: ResponseType.bytes));

      if (response.data == null || response.data!.isEmpty) {
        throw Exception('Document data is empty');
      }

      final bytes = Uint8List.fromList(response.data!);
      final document = await PdfDocument.openData(bytes);
      final page = await document.getPage(1);
      final pageImage = await page.render(width: page.width, height: page.height, format: PdfPageImageFormat.png);

      await page.close();
      await document.close();

      return pageImage?.bytes;
    } catch (e, st) {
      log('DOCUMENT MEDIA PREVIEW ERROR: $e');
      log('DOCUMENT MEDIA PREVIEW STACK: $st');

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.grey.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<Uint8List?>(
              future: _previewFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)), strokeWidth: 3)));
                }
                final bytes = snapshot.data;

                if (bytes == null || bytes.isEmpty) {
                  return _buildFallback();
                }

                return Image.memory(bytes, fit: BoxFit.cover, alignment: Alignment.topCenter);
              },
            ),
          ),
          Positioned(
            left: 3,
            right: 3,
            bottom: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(color: ChatifyColors.black.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(4)),
              child: Text(
                widget.media.fileName ?? 'Документ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(color: ChatifyColors.white, fontSize: 11, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallback() {
    return Center(child: Icon(Icons.insert_drive_file_outlined, color: ChatifyColors.lightBlueLink, size: 30));
  }
}
