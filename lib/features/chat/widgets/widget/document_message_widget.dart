import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:open_filex_plus/open_filex_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import '../../../../api/apis.dart';
import '../../../../data/file_extensions_data.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/message_model.dart';

class DocumentMessageWidget extends StatefulWidget {
  final MessageModel message;
  final bool isSender;

  const DocumentMessageWidget({
    super.key,
    required this.message,
    required this.isSender,
  });

  @override
  State<DocumentMessageWidget> createState() => _DocumentMessageWidgetState();
}

class _DocumentMessageWidgetState extends State<DocumentMessageWidget> {
  Future<Widget>? _documentPreviewFuture;
  int? _pageCount;

  @override
  void initState() {
    super.initState();

    final fileName = widget.message.documentName ?? 'Unknown';
    final fileExtension = fileName.split('.').last.toLowerCase();

    _documentPreviewFuture = _buildDocumentPreview(fileExtension);
  }

  Future<Widget> _buildDocumentPreview(String fileExtension) async {
    try {
      final mediaPath = widget.message.msg;

      log('DOCUMENT PREVIEW: path = $mediaPath');

      final url = await APIs.getMediaUrl(mediaPath);

      if (url == null || url.isEmpty) {
        throw Exception('Document URL is empty');
      }

      log('DOCUMENT PREVIEW: url = $url');

      final response = await Dio().get<List<int>>(url, options: Options(responseType: ResponseType.bytes));
      final bytes = Uint8List.fromList(response.data!);
      final document = await PdfDocument.openData(bytes);
      if (mounted) {
        setState(() {
          _pageCount = document.pagesCount;
        });
      }
      final page = await document.getPage(1);
      final pageImage = await page.render(width: page.width, height: page.height, format: PdfPageImageFormat.png);

      await page.close();
      await document.close();

      if (pageImage == null) {
        return getFileIconWidget(fileExtension);
      }

      return Transform.scale(scale: 2.2, alignment: Alignment.topCenter, child: Image.memory(pageImage.bytes, fit: BoxFit.fitWidth, alignment: Alignment.topCenter));
    } catch (e, st) {
      log('DOCUMENT PREVIEW ERROR: $e');
      log('DOCUMENT PREVIEW STACK: $st');

      return getFileIconWidget(fileExtension);
    }
  }

  Future<void> _openDocument() async {
    try {
      final mediaPath = widget.message.msg;

      log('OPEN DOCUMENT: path = $mediaPath');

      final url = await APIs.getMediaUrl(mediaPath);

      if (url == null || url.isEmpty) {
        throw Exception('Document URL is empty');
      }

      final directory = await getTemporaryDirectory();
      final fileName = widget.message.documentName ?? 'document';
      final file = File('${directory.path}/$fileName');

      if (!await file.exists()) {
        final response = await Dio().get<List<int>>(url, options: Options(responseType: ResponseType.bytes));

        await file.writeAsBytes(response.data!);
      }

      final result = await OpenFilex.open(file.path);

      log('OPEN DOCUMENT: ${result.type} ${result.message}');
    } catch (e, st) {
      log('OPEN DOCUMENT ERROR: $e');
      log('OPEN DOCUMENT STACK: $st');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.message.documentName ?? 'Unknown';
    final fileExtension = fileName.split('.').last.toLowerCase();
    final fileTypeDescription = FileExtensionsData.fileTypeDescriptions[fileExtension] ?? fileExtension.toUpperCase();
    final fileSizeValue = widget.message.fileSize ?? '';
    final cleanedFileSize = Formatter.cleanFileSizeString(fileSizeValue);
    final double fileSizeBytes = double.tryParse(cleanedFileSize) ?? 0;
    final fileSize = fileSizeBytes > 0 ? Formatter.formatFileSize(fileSizeBytes) : 'Unknown size';
    final infoBackgroundColor = context.isDarkMode ? ChatifyColors.black.withAlpha((0.18 * 255).toInt()) : ChatifyColors.black.withAlpha((0.06 * 255).toInt());

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.15 * 255).toInt()) : ChatifyColors.grey,
          onTap: () {
            _openDocument();
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 0))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 85,
                    color: ChatifyColors.white,
                    child: FutureBuilder<Widget>(
                      future: _documentPreviewFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)),
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return Center(child: getFileIconWidget(fileExtension));
                        }

                        return ClipRect(child: Align(alignment: Alignment.topCenter, child: snapshot.data!));
                      },
                    ),
                  ),
                  Container(
                    color: infoBackgroundColor,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w400, height: 1.2),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_pageCount ?? '...'} ${_pageCount == 1 ? 'страница' : 'страниц'} · ''$fileSize · $fileTypeDescription',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300, height: 1.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFileIconWidget(String fileExtension) {
    switch (fileExtension.toLowerCase()) {
      case 'pdf':
        return SvgPicture.asset(ChatifyVectors.filePdf, width: 28, height: 28);
      case 'doc':
      case 'docx':
        return SvgPicture.asset(ChatifyVectors.fileDoc, width: 28, height: 28);
      case 'xls':
      case 'xlsx':
        return SvgPicture.asset(ChatifyVectors.fileXls, width: 28, height: 28);
      case 'zip':
      case 'rar':
        return Icon(Icons.archive, color: ChatifyColors.orange);
      case 'apk':
        return Icon(Icons.android, color: ChatifyColors.green);
      default:
        return Icon(Icons.insert_drive_file, color: ChatifyColors.grey);
    }
  }
}
