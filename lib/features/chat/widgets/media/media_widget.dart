import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:http/http.dart' as http;
import 'package:chatify/utils/popups/dialogs.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import '../../../../../generated/l10n/l10n.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/helper/gif_loading_indicator.dart';
import '../../../../data/file_extensions_data.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../../video_player/widgets/video_player_widget.dart';
import '../../models/message_model.dart';
import '../audio/audio_widget.dart';
import '../../screens/full_screen_image_screen.dart';
import '../image/full_screen_image_widget.dart';

class MediaWidget extends StatefulWidget {
  final MessageModel message;
  final bool isSender;
  final bool isDownloading;
  final Function onDownload;
  final List<String> imageUrls;

  const MediaWidget({
    super.key,
    required this.message,
    required this.isSender,
    required this.isDownloading,
    required this.onDownload,
    required this.imageUrls,
  });

  @override
  MediaWidgetState createState() => MediaWidgetState();
}

class MediaWidgetState extends State<MediaWidget> {
  bool isDownloading = false;
  final logger = Logger();

  void onOpenDocument() async {
    try {
      final url = widget.message.msg;
      await launchUrl(Uri.parse(url));
    } catch (e) {
      logger.e('Ошибка при открытии документа: $e');
      Dialogs.showSnackbar(context, 'Не удалось открыть документ.');
    }
  }

  void onDownload() async {
    setState(() {
      isDownloading = true;
    });

    try {
      logger.d('Starting document download...');
      final response = await http.get(Uri.parse(widget.message.msg));

      if (response.statusCode == 200) {
        logger.d('Download successful');

        if (kIsWeb) {
          final blob = html.Blob([response.bodyBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          html.AnchorElement(href: url)..download = widget.message.documentName ?? 'document'..click();
          html.Url.revokeObjectUrl(url);

          logger.d('Web download triggered');
        } else {
          final directory = await getExternalStorageDirectory();
          final filePath = '${directory!.path}/${widget.message.documentName ?? 'document'}';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          logger.d('File saved to $filePath');
          Dialogs.showSnackbar(context, S.of(context).documentSuccessfullySaved);
        }
      } else {
        logger.d('Failed to download document, status code: ${response.statusCode}');
        Dialogs.showSnackbar(context, S.of(context).failedDownloadDocument);
      }
    } catch (e) {
      logger.d('Error downloading document: $e');
      Dialogs.showSnackbar(context, 'Error: $e');
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.message.type) {
      case Type.image:
        return _buildImageWidget(context);
      case Type.gif:
        return _buildGifWidget(context);
      case Type.video:
        final urls = widget.message.msg.split(',').map((e) => e.trim()).toList();
        return VideoPlayerWidget(videoUrls: urls, message: widget.message);
      case Type.audio:
        return AudioWidget(
          audioUrl: widget.message.msg,
          documentName: widget.message.documentName ?? 'Unknown',
          fileSize: widget.message.fileSize ?? 'Unknown size',
          isSender: widget.isSender,
        );
      case Type.document:
        return _buildDocumentWidget(context, isSender: widget.isSender);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImageWidget(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(10));
    int index = widget.imageUrls.indexWhere((url) => url.trim() == widget.message.msg.trim());
    final currentIndex = (index >= 0 && widget.imageUrls.isNotEmpty) ? index.clamp(0, widget.imageUrls.length - 1) : 0;

    return ClipRRect(
      borderRadius: borderRadius,
      child: GestureDetector(
        onTap: () {
          if (Platform.isWindows) {
            showDialog(context: context, builder: (context) => FullScreenImageWidget(imageUrls: widget.imageUrls, initialIndex: currentIndex));
          } else {
            Navigator.push(context, createPageRoute(FullScreenImageScreen(imageUrls: widget.imageUrls, initialIndex: currentIndex)));
          }
        },
        child: Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(borderRadius: borderRadius),
          child: CachedNetworkImage(
            imageUrl: widget.message.msg,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(color: ChatifyColors.transparent),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(ChatifyColors.black.withAlpha((0.5 * 255).toInt()), BlendMode.darken),
                child: const SizedBox.expand(),
              ),
            ),
            imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover, width: 250, height: 250),
            errorWidget: (context, url, error) => const Icon(Icons.image, size: 70),
          ),
        ),
      ),
    );
  }

  Widget _buildGifWidget(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: widget.message.msg,
        placeholder: (context, url) => const Padding(padding: EdgeInsets.all(8.0), child: GifLoadingIndicator(text: 'Gif')),
        errorWidget: (context, url, error) => const HeroIcon(HeroIcons.gif, size: 70),
      ),
    );
  }

  Widget _buildDocumentWidget(BuildContext context, {required bool isSender}) {
    final fileName = widget.message.documentName ?? 'Unknown';
    final fileExtension = fileName.split('.').last.toLowerCase();
    final fileTypeDescription = FileExtensionsData.fileTypeDescriptions[fileExtension] ?? fileExtension.toUpperCase();
    final fileSizeValue = widget.message.fileSize ?? '';
    final cleanedFileSize = Formatter.cleanFileSizeString(fileSizeValue);
    double fileSizeBytes = double.tryParse(cleanedFileSize) ?? 0;
    final fileSize = fileSizeBytes > 0 ? Formatter.formatFileSize(fileSizeBytes) : 'Unknown size';
    final backgroundColor = isSender ? (context.isDarkMode ? ChatifyColors.greenMessageBorderLight : ChatifyColors.greenMessageLight) : (context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.white);
    final borderColor = isSender ? (context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBorder) : (context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.lightGrey);
    final dividerColor = isSender ? (context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.greenMessageBorder) : (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.lightGrey);
    final buttonColor = isSender ? (context.isDarkMode ? ChatifyColors.greenMessageButton : ChatifyColors.greenMessageBorder) : (context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.6 * 255).toInt()) : ChatifyColors.lightGrey);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 10),
              child: Row(
                children: [
                  getFileIconWidget(fileExtension),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 13, fontWeight: FontWeight.w300, fontFamily: 'Roboto', height: 1.2),
                        ),
                        const SizedBox(height: 2),
                        Text('$fileSize, $fileTypeDescription', style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeLm, fontFamily: 'Roboto', fontWeight: FontWeight.w300, height: 1.2)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0, thickness: 1, color: dividerColor),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
              child: isSender
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isDownloading ? null : () => onDownload(),
                      label: const Text('Скачать'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide.none,
                        textStyle: TextStyle(fontSize: ChatifySizes.fontSizeSm),
                      ),
                    ),
                  )
                : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isDownloading ? null : () => onOpenDocument(),
                        label: const Text('Открыть'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: TextStyle(fontSize: ChatifySizes.fontSizeSm),
                          side: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isDownloading ? null : () => onDownload(),
                        label: Text('Сохранить как', overflow: TextOverflow.ellipsis),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          textStyle: TextStyle(fontSize: ChatifySizes.fontSizeSm),
                          side: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ],
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
