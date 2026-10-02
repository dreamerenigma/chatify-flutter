import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatify/utils/constants/app_sizes.dart';
import 'package:chatify/utils/constants/app_vectors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';

class AudioWidget extends StatefulWidget {
  final String documentName;
  final String fileSize;
  final String audioUrl;
  final bool isSender;
  final int? audioDuration;

  const AudioWidget({
    super.key,
    required this.audioUrl,
    required this.documentName,
    required this.fileSize,
    required this.isSender,
    this.audioDuration,
  });

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late String fileNameWithExtension;
  late String generatedFileName;
  bool isPlaying = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String? _localAudioPath;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  CancelToken? _downloadCancelToken;

  Duration get initialAudioDuration => Duration(seconds: widget.audioDuration ?? 0);

  String _formatDuration(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    _initializeFileName();
    _initializeAudioListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initializeFileName() {
    final uri = Uri.tryParse(widget.audioUrl);

    if (uri != null) {
      final decodedPath = Uri.decodeComponent(uri.path);

      fileNameWithExtension = p.basename(decodedPath);

      final formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());

      generatedFileName = 'AUD-$formattedDate-${p.basenameWithoutExtension(decodedPath)}';
    } else {
      fileNameWithExtension = widget.documentName;
      generatedFileName = widget.documentName;
    }
  }

  void _initializeAudioListeners() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (!mounted) return;

      setState(() {
        duration = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (!mounted) return;

      setState(() {
        position = newPosition;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;

      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  Future<void> _togglePlayPause() async {
    if (_localAudioPath == null) return;

    if (isPlaying) {
      await _audioPlayer.pause();

      if (!mounted) return;

      setState(() {
        isPlaying = false;
      });
    } else {
      await _audioPlayer.play(
        DeviceFileSource(_localAudioPath!),
      );

      if (!mounted) return;

      setState(() {
        isPlaying = true;
      });
    }
  }

  Future<void> _seekAudio(double value) async {
    if (duration == Duration.zero) return;

    final newPosition = Duration(milliseconds: (duration.inMilliseconds * value).round());

    await _audioPlayer.seek(newPosition);
  }

  Future<void> _downloadAudio() async {
    if (_isDownloading) return;

    try {
      _downloadCancelToken = CancelToken();

      setState(() {
        _isDownloading = true;
        _downloadProgress = 0.0;
      });

      final directory = await getApplicationDocumentsDirectory();
      final fileName = widget.audioUrl.split('/').last.split('?').first;
      final filePath = '${directory.path}/$fileName';

      await Dio().download(
        widget.audioUrl,
        filePath,
        cancelToken: _downloadCancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      if (!mounted) return;

      setState(() {
        _localAudioPath = filePath;
        _isDownloading = false;
        _downloadProgress = 1.0;
      });
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        log('AUDIO DOWNLOAD: cancelled');
      } else {
        log('AUDIO DOWNLOAD ERROR: $e');
      }

      if (!mounted) return;

      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });
    } catch (e) {
      log('AUDIO DOWNLOAD ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });
    } finally {
      _downloadCancelToken = null;
    }
  }

  Future<void> _cancelDownload() async {
    _downloadCancelToken?.cancel();

    if (mounted) {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.documentName.isNotEmpty ? widget.documentName : S.of(context).unknown;
    final cleanedFileSize = Formatter.cleanFileSizeString(widget.fileSize);
    final fileSizeBytes = double.tryParse(cleanedFileSize) ?? 0;
    final formattedFileSize = fileSizeBytes > 0 ? Formatter.formatFileSize(fileSizeBytes) : '0 KB';
    final progressColor = widget.isSender
      ? (context.isDarkMode ? colorsController.getColor(colorsController.selectedColorScheme.value) : ChatifyColors.greenMessageBorder)
      : (context.isDarkMode ? ChatifyColors.steelGrey : ChatifyColors.lightGrey);
    final iconColor = context.isDarkMode ? ChatifyColors.white : ChatifyColors.black;
    final progressValue = duration.inMilliseconds > 0 ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(shape: BoxShape.circle, color: ChatifyColors.orange),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.headset_outlined, size: 25, color: iconColor),
                  Text(
                    position > Duration.zero ? _formatDuration(position) : _formatDuration(initialAudioDuration),
                    style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 11, fontWeight: FontWeight.w400, height: 1),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_isDownloading) {
                          _cancelDownload();
                        } else if (_localAudioPath == null) {
                          _downloadAudio();
                        } else {
                          _togglePlayPause();
                        }
                      },
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: _isDownloading
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    value: _downloadProgress,
                                    strokeWidth: 2.5,
                                    color: ChatifyColors.primary,
                                    backgroundColor: ChatifyColors.primary.withAlpha(40),
                                  ),
                                ),
                                const Icon(Icons.close_rounded, size: 20, color: ChatifyColors.iconGrey),
                              ],
                            )
                            : _localAudioPath == null
                              ? const Icon(Icons.file_download_outlined, size: 29, color: ChatifyColors.iconGrey)
                              : isPlaying
                                ? SvgPicture.asset(ChatifyVectors.pauseFilled, width: 32, height: 32, colorFilter: ColorFilter.mode(ChatifyColors.iconGrey, BlendMode.srcIn))
                                : SvgPicture.asset(ChatifyVectors.playFilled, width: 32, height: 32, colorFilter: ColorFilter.mode(ChatifyColors.iconGrey, BlendMode.srcIn)),
                      ),
                    ),
                    Flexible(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            padding: EdgeInsets.only(left: 12, right: 0, top: 6, bottom: 6),
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                            activeTrackColor: progressColor,
                            inactiveTrackColor: ChatifyColors.greenMessageButton,
                            thumbColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                            disabledThumbColor: ChatifyColors.primary,
                            overlayColor: progressColor.withAlpha((0.15 * 255).toInt()),
                          ),
                          child: Slider(value: progressValue, min: 0, max: 1, onChanged: duration == Duration.zero ? null : _seekAudio),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _localAudioPath != null ? fileName : formattedFileSize,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: context.isDarkMode ? ChatifyColors.iconGrey : ChatifyColors.black,
                            fontSize: ChatifySizes.fontSizeLm,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
