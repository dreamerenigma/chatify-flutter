import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gif_view/gif_view.dart';
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
import '../../../../api/apis.dart';
import '../../../../core/enums/message_type.dart';
import '../../../../core/enums/snack_bar_position_type.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../../video_player/widgets/video_player_widget.dart';
import '../../models/message_model.dart';
import '../audio/audio_widget.dart';
import '../../screens/full_screen_image_screen.dart';
import '../image/full_screen_image_widget.dart';
import 'document_message_widget.dart';

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
  final logger = Logger();
  final GifController _gifController = GifController();
  bool isGifPlaying = false;
  bool isDownloading = false;
  bool _isImageLoading = true;
  bool _isAudioLoading = true;
  Map<String, String> _resolvedImageUrls = {};
  String? _resolvedAudioUrl;
  Timer? _gifTimer;

  @override
  void initState() {
    super.initState();
    _resolveImageUrls();
    if (widget.message.type == MessageType.audio) {
      _resolveAudioUrl();
    }
  }

  @override
  void dispose() {
    _gifTimer?.cancel();
    _gifController.stop();
    super.dispose();
  }

  void onOpenDocument() async {
    try {
      final url = widget.message.msg;

      await launchUrl(Uri.parse(url));
    } catch (e) {
      log('Ошибка при открытии документа: $e');
      CustomIconSnackBar.showAnimatedSnackBar(
        context,
        'Не удалось открыть документ',
        icon: SvgPicture.asset(ChatifyVectors.closeCircle, width: 24, height: 24, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
        iconColor: ChatifyColors.danger,
        position: SnackBarPositionType.bottom,
        offset: 40
      );
    }
  }

  void onDownload() async {
    setState(() {
      isDownloading = true;
    });

    try {
      log('Starting document download...');
      final response = await http.get(Uri.parse(widget.message.msg));

      if (response.statusCode == 200) {
        log('Download successful');

        if (kIsWeb) {
          final blob = html.Blob([response.bodyBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);

          html.AnchorElement(href: url)..download = widget.message.documentName ?? 'document'..click();
          html.Url.revokeObjectUrl(url);

          log('Web download triggered');
        } else {
          final directory = await getExternalStorageDirectory();
          final filePath = '${directory!.path}/${widget.message.documentName ?? 'document'}';
          final file = File(filePath);

          await file.writeAsBytes(response.bodyBytes);
          log('File saved to $filePath');
          Dialogs.showSnackbar(context, S.of(context).documentSuccessfullySaved);
        }
      } else {
        log('Failed to download document, status code: ${response.statusCode}');
        Dialogs.showSnackbar(context, S.of(context).failedDownloadDocument);
      }
    } catch (e) {
      log('Error downloading document: $e');
      Dialogs.showSnackbar(context, 'Error: $e');
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  void _playGif() {
    if (isGifPlaying) return;

    _gifTimer?.cancel();

    setState(() {
      isGifPlaying = true;
    });

    _gifController.play();

    _gifTimer = Timer(
      const Duration(seconds: 5),
      () {
        if (!mounted) return;

        _gifController.stop();

        setState(() {
          isGifPlaying = false;
        });
      },
    );
  }

  Future<void> _resolveImageUrls() async {
    try {
      final result = <String, String>{};

      for (final path in widget.imageUrls) {
        final trimmedPath = path.trim();
        final url = await APIs.getMediaUrl(trimmedPath);

        if (url != null && url.isNotEmpty) {
          result[trimmedPath] = url;
        }
      }

      if (!mounted) return;

      setState(() {
        _resolvedImageUrls = result;
        _isImageLoading = false;
      });
    } catch (e, st) {
      log('MEDIA WIDGET: failed to resolve image URLs: $e');
      log('MEDIA WIDGET: stack = $st');

      if (!mounted) return;

      setState(() {
        _isImageLoading = false;
      });
    }
  }

  Future<void> _resolveAudioUrl() async {
    try {
      final path = widget.message.msg.trim();
      final url = await APIs.getMediaUrl(path);

      if (!mounted) return;

      setState(() {
        _resolvedAudioUrl = url;
        _isAudioLoading = false;
      });
    } catch (e, st) {
      log('MEDIA WIDGET: failed to resolve audio URL: $e');
      log('MEDIA WIDGET: stack = $st');

      if (!mounted) return;

      setState(() {
        _isAudioLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.message.type) {
      case MessageType.image:
        return _buildImageWidget(context);
      case MessageType.gif:
        return _buildGifWidget(context);
      case MessageType.video:
        final urls = widget.message.msg.split(',').map((e) => e.trim()).toList();

        return VideoPlayerWidget(videoUrls: urls, message: widget.message);
      case MessageType.audio:
        if (_isAudioLoading) {
          return SizedBox(width: 300, height: 100, child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value)))));
        }

        if (_resolvedAudioUrl == null || _resolvedAudioUrl!.isEmpty) {
          return const SizedBox(width: 300, height: 100, child: Center(child: Icon(Icons.error_outline)));
        }

        return AudioWidget(
          audioUrl: _resolvedAudioUrl!,
          documentName: widget.message.documentName ?? 'Unknown',
          fileSize: widget.message.fileSize ?? 'Unknown size',
          isSender: widget.isSender,
          audioDuration: widget.message.audioDuration,
        );
      case MessageType.document:
        return DocumentMessageWidget(isSender: widget.isSender, message: widget.message);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImageWidget(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(10));
    final currentPath = widget.message.msg.trim();
    final currentUrl = _resolvedImageUrls[currentPath];
    final resolvedImageUrls = widget.imageUrls.map((path) => _resolvedImageUrls[path.trim()]).whereType<String>().where((url) => url.isNotEmpty).toList();
    final index = widget.imageUrls.map((path) => path.trim()).toList().indexOf(currentPath);
    final currentIndex = index >= 0 ? index : 0;

    return ClipRRect(
      borderRadius: borderRadius,
      child: GestureDetector(
        onTap: () {
          if (resolvedImageUrls.isEmpty) return;

          if (Platform.isWindows) {
            showDialog(
              context: context,
              builder: (context) => FullScreenImageWidget(imageUrls: resolvedImageUrls, initialIndex: currentIndex.clamp(0, resolvedImageUrls.length - 1)),
            );
          } else {
            Navigator.push(context, createPageRoute(FullScreenImageScreen(imageUrls: resolvedImageUrls, initialIndex: currentIndex.clamp(0, resolvedImageUrls.length - 1))));
          }
        },
        child: Container(
          width: 250,
          height: 230,
          decoration: BoxDecoration(borderRadius: borderRadius),
          child: _isImageLoading || currentUrl == null
            ? Container(
                width: 250,
                height: 230,
                decoration: const BoxDecoration(color: ChatifyColors.transparent), child: ColorFiltered(colorFilter: ColorFilter.mode(ChatifyColors.black.withAlpha((0.5 * 255).toInt(),), BlendMode.darken), child: const SizedBox.expand(),),
              )
            : CachedNetworkImage(
                imageUrl: currentUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 250,
                  height: 230,
                  decoration: const BoxDecoration(color: ChatifyColors.transparent),
                  child: ColorFiltered(colorFilter: ColorFilter.mode(ChatifyColors.black.withAlpha((0.5 * 255).toInt(),), BlendMode.darken), child: const SizedBox.expand()),
                ),
                imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover, width: 230, height: 230),
                errorWidget: (context, url, error) {
                  log('MEDIA WIDGET: image loading error: $error');

                  return const Icon(Icons.image, size: 70);
                },
              ),
        ),
      ),
    );
  }

  Widget _buildGifWidget(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 250,
        height: 230,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GifView.network(
              widget.message.msg,
              controller: _gifController,
              width: 250,
              height: 230,
              fit: BoxFit.cover,
              loop: true,
              progressBuilder: (context) {
                return const Padding(padding: EdgeInsets.all(8), child: GifLoadingIndicator(text: 'Gif'));
              },
              errorBuilder: (context, error, tryAgain) {
                return const Center(child: HeroIcon(HeroIcons.gif, size: 70));
              },
            ),
            if (!isGifPlaying)
              GestureDetector(
                onTap: _playGif,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.55), shape: BoxShape.circle),
                  child: SvgPicture.asset(ChatifyVectors.gif, width: 38, height: 38, colorFilter: ColorFilter.mode(ChatifyColors.white, BlendMode.srcIn)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
