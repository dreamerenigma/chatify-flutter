import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
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
  final bool isUploading;
  final bool isUploadFailed;
  final String? localImagePath;
  final Function onDownload;
  final List<String> imageUrls;
  final ValueChanged<Duration>? onVideoPositionChanged;
  final VoidCallback? onVideoStarted;

  const MediaWidget({
    super.key,
    required this.message,
    required this.isSender,
    required this.isDownloading,
    required this.onDownload,
    required this.imageUrls,
    this.onVideoPositionChanged,
    this.onVideoStarted,
    this.localImagePath,
    this.isUploading = false,
    this.isUploadFailed = false,
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
      final response = await http.get(Uri.parse(widget.message.msg));

      if (response.statusCode == 200) {

        if (kIsWeb) {
          final blob = html.Blob([response.bodyBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);

          html.AnchorElement(href: url)..download = widget.message.documentName ?? 'document'..click();
          html.Url.revokeObjectUrl(url);
        } else {
          final directory = await getExternalStorageDirectory();
          final filePath = '${directory!.path}/${widget.message.documentName ?? 'document'}';
          final file = File(filePath);

          await file.writeAsBytes(response.bodyBytes);
          Dialogs.showSnackbar(context, S.of(context).documentSuccessfullySaved);
        }
      } else {
        Dialogs.showSnackbar(context, S.of(context).failedDownloadDocument);
      }
    } catch (e) {
      Dialogs.showSnackbar(context, 'Error: $e');
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
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

      final gifPath = widget.message.msg.trim();

      if (gifPath.isNotEmpty) {
        final gifUrl = await APIs.getMediaUrl(gifPath);

        if (gifUrl != null && gifUrl.isNotEmpty) {
          result[gifPath] = gifUrl;
        }
      }

      if (!mounted) return;

      setState(() {
        _resolvedImageUrls = result;
        _isImageLoading = false;
      });
    } catch (e, st) {
      log('MEDIA WIDGET: failed to resolve media URLs: $e');
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

        return VideoPlayerWidget(videoUrls: urls, message: widget.message, onPositionChanged: widget.onVideoPositionChanged, onVideoStarted: widget.onVideoStarted);
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
        return SizedBox(width: 280, height: 160, child: DocumentMessageWidget(isSender: widget.isSender, message: widget.message));
      default:
        return const SizedBox.shrink();
    }
  }


  Widget _buildImageWidget(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(14));

    final currentPath = widget.message.msg.trim();
    final currentUrl = _resolvedImageUrls[currentPath];
    final resolvedImageUrls = widget.imageUrls.map((path) => _resolvedImageUrls[path.trim()]).whereType<String>().where((url) => url.isNotEmpty).toList();
    final index = widget.imageUrls.map((path) => path.trim()).toList().indexOf(currentPath);
    final currentIndex = index >= 0 ? index : 0;
    final localPath = widget.localImagePath;
    final hasLocalFile = localPath != null && localPath.isNotEmpty && File(localPath).existsSync();
    final showLocalPreview = widget.isUploading && hasLocalFile;
    final showLoadingOverlay = widget.isUploading || (!showLocalPreview && (currentUrl == null || currentUrl.isEmpty));

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
            Navigator.push(
              context,
              createPageRoute(FullScreenImageScreen(imageUrls: resolvedImageUrls, initialIndex: currentIndex.clamp(0, resolvedImageUrls.length - 1), message: widget.message)),
            );
          }
        },
        child: SizedBox(
          width: 250,
          height: 230,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              if (showLocalPreview)
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Image.file(
                    File(localPath),
                    width: 250,
                    height: 230,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const ColoredBox(color: Color(0xFF252525));
                    },
                  ),
                )
              else if (currentUrl != null && currentUrl.isNotEmpty)
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: _isImageLoading ? 8 : 0, sigmaY: _isImageLoading ? 8 : 0),
                  child: CachedNetworkImage(
                    imageUrl: currentUrl,
                    fit: BoxFit.cover,
                    width: 250,
                    height: 230,
                    placeholder: (context, url) => const SizedBox(width: 250, height: 230,),
                    imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover, width: 250, height: 230),
                    errorWidget: (context, url, error) {
                      log('MEDIA WIDGET: image loading error: $error');
                      return const Icon(Icons.image, size: 70);
                    },
                  ),
                )

              else
                const ColoredBox(color: Color(0xFF252525)),
              if (showLoadingOverlay)
                _buildImageLoadingOverlay(),
              if (widget.isUploadFailed)
                Container(color: ChatifyColors.black, alignment: Alignment.center, child: const Icon(Icons.error_outline, size: 32, color: ChatifyColors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGifWidget(BuildContext context) {
    final gifUrl = _resolvedImageUrls[widget.message.msg.trim()];

    if (gifUrl == null || gifUrl.isEmpty) {
      return const SizedBox(width: 250, height: 230, child: Center(child: HeroIcon(HeroIcons.gif, size: 70)));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 250,
        height: 230,
        child: GestureDetector(
          onTap: () {
            final imageUrls = [gifUrl];

            if (Platform.isWindows) {
              showDialog(context: context, builder: (context) => FullScreenImageWidget(imageUrls: imageUrls, initialIndex: 0));
            } else {
              Navigator.push(context, createPageRoute(FullScreenImageScreen(imageUrls: imageUrls, initialIndex: 0, message: widget.message)));
            }
          },
          child: GifView.network(
            gifUrl,
            width: 250,
            height: 230,
            fit: BoxFit.cover,
            loop: true,
            progressBuilder: (context) {
              return const Padding(padding: EdgeInsets.all(8), child: GifLoadingIndicator(text: 'Gif'));
            },
            errorBuilder: (context, error, tryAgain) {
              log('GIF WIDGET: loading error = $error');

              return const Center(child: HeroIcon(HeroIcons.gif, size: 70));
            },
          ),
        ),
      ),
    );
  }


  Widget _buildImageLoadingOverlay() {
    return Container(
      width: 250,
      height: 230,
      decoration: BoxDecoration(color: ChatifyColors.black.withValues(alpha: 5), borderRadius: const BorderRadius.all(Radius.circular(14))),
      child: Center(
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(color: ChatifyColors.black.withAlpha(100), shape: BoxShape.circle),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(ChatifyColors.white), backgroundColor: ChatifyColors.white.withAlpha(70)),
              ),
              const Icon(Icons.close_rounded, size: 21, color: ChatifyColors.white),
            ],
          ),
        ),
      ),
    );
  }
}
