import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import '../../../../../utils/constants/app_colors.dart';
import '../../../../data/file_extensions_data.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/formatters/formatter.dart';

class AudioWidget extends StatefulWidget {
  final String documentName;
  final String fileSize;
  final String audioUrl;
  final bool isSender;

  const AudioWidget({
    super.key,
    required this.audioUrl,
    required this.documentName,
    required this.fileSize,
    required this.isSender,
  });

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> {
  late String fileNameWithExtension;
  late String fileName;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration? duration;
  Duration? position;

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void initState() {
    super.initState();
    Uri uri = Uri.parse(widget.audioUrl);
    String decodedPath = Uri.decodeComponent(uri.path);
    fileNameWithExtension = p.basename(decodedPath);

    String formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());

    fileName = 'AUD-$formattedDate-${p.basenameWithoutExtension(decodedPath)}';

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        duration = d;
      });
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.documentName.isNotEmpty ? widget.documentName : S.of(context).unknown;
    final fileExtension = fileName.split('.').last.toLowerCase();
    final fileTypeDescription = FileExtensionsData.fileTypeDescriptions[fileExtension] ?? fileExtension.toUpperCase();
    final fileSizeValue = widget.fileSize;
    final cleanedFileSize = Formatter.cleanFileSizeString(fileSizeValue);
    double fileSizeBytes = double.tryParse(cleanedFileSize) ?? 0;
    final fileSize = fileSizeBytes > 0 ? Formatter.formatFileSize(fileSizeBytes) : S.of(context).unknownSize;
    final backgroundColor = widget.isSender ? (context.isDarkMode ? ChatifyColors.greenMessageBorderLight : ChatifyColors.greenMessageLight) : (context.isDarkMode ? ChatifyColors.darkerGrey : ChatifyColors.white);
    final borderColor = widget.isSender ? (context.isDarkMode ? ChatifyColors.greenMessageBorderDark : ChatifyColors.greenMessageBorder) : (context.isDarkMode ? ChatifyColors.lightSoftNight : ChatifyColors.lightGrey);
    final dividerColor = widget.isSender ? (context.isDarkMode ? ChatifyColors.greenMessageDivider : ChatifyColors.greenMessageBorder) : (context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.lightGrey);
    final buttonColor = widget.isSender ? (context.isDarkMode ? ChatifyColors.greenMessageButton : ChatifyColors.greenMessageBorder) : (context.isDarkMode ? ChatifyColors.steelGrey.withAlpha((0.6 * 255).toInt()) : ChatifyColors.lightGrey);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
                  SvgPicture.asset(ChatifyVectors.fileAudio, width: 30, height: 30),
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
                        Text('$fileSize, ${S.of(context).file} \'${fileTypeDescription.toUpperCase()}\'', style: TextStyle(color: ChatifyColors.grey, fontSize: ChatifySizes.fontSizeLm, fontFamily: 'Roboto', fontWeight: FontWeight.w300, height: 1.2)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0, thickness: 1, color: dividerColor),
            if (!(Platform.isAndroid || Platform.isIOS))
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
              child: widget.isSender
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      label: Text(S.of(context).download),
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
                        onPressed: () {},
                        label: Text(S.of(context).open),
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
                        onPressed: () {},
                        label: Text(S.of(context).saveAs, overflow: TextOverflow.ellipsis),
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
}
