import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:icon_forest/iconoir.dart';
import '../../../../utils/constants/app_colors.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/popups/custom_tooltip.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../common/widgets/animations/blink_animation.dart';
import '../dialogs/edit_text_dialog.dart';

class BottomInput extends StatefulWidget {
  final TextEditingController textController;
  final FocusNode focusNode;
  final bool isHovered;
  final VoidCallback sendMessage;
  final Future<void> Function() showEmojiStickersDialog;
  final Future<void> Function() showAttachFileDialog;
  final Function(String) onEmojiSelected;
  final Function(String) onGifSelected;
  final GlobalKey textFieldKey;

  const BottomInput({
    super.key,
    required this.textController,
    required this.focusNode,
    required this.isHovered,
    required this.sendMessage,
    required this.showEmojiStickersDialog,
    required this.showAttachFileDialog,
    required this.onEmojiSelected,
    required this.textFieldKey,
    required this.onGifSelected,
  });

  @override
  State<BottomInput> createState() => _BottomInputState();
}

class _BottomInputState extends State<BottomInput> {
  Duration recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  double _thumbPosition = 0.0;
  final double _dotSpacing = 4.4;
  final int _dotCount = 25;
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  String? _audioFilePath;
  bool isHovered = false;
  bool hasText = false;
  bool isRecording = false;
  bool isPlaying = false;
  bool isPaused = false;
  bool isEmojiDialogOpen = false;
  bool isAttachDialogOpen = false;

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(_onTextChanged);
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_onTextChanged);
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final currentHasText = widget.textController.text.trim().isNotEmpty;
    if (currentHasText != hasText) {
      setState(() {
        hasText = currentHasText;
      });
    }
  }

  void _onFocusChanged() {
    setState(() {
      if (widget.focusNode.hasFocus) {
        log('Поле получило фокус');
      } else {
        log('Поле потеряло фокус');
      }
    });
  }

  Future<void> startRecording() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      setState(() {
        isRecording = true;
        isPaused = false;
        recordingDuration = Duration.zero;
      });

      _recordingTimer = Timer.periodic(Duration(seconds: 1), (_) {
        if (isRecording && !isPaused) {
          setState(() {
            recordingDuration += Duration(seconds: 1);
          });
        }
      });

      String filePath = 'audio_message.aac';
      await _audioRecorder.startRecorder(toFile: filePath, codec: Codec.aacADTS);

      setState(() {
        _audioFilePath = filePath;
      });
    } else {
      log("Microphone permission denied");
    }
  }

  Future<void> stopRecording() async {
    final path = await _audioRecorder.stopRecorder();
    setState(() {
      isRecording = false;
      _audioFilePath = path;
    });

    _recordingTimer?.cancel();
    log('Recording saved at: $_audioFilePath');
  }

  Future<void> playRecording() async {
    if (_audioFilePath != null) {
      await _audioPlayer.startPlayer(fromURI: _audioFilePath, codec: Codec.aacADTS);
      setState(() {
        isPlaying = true;
      });
    } else {
      log("No audio file found to play.");
    }
  }

  Future<void> stopPlaying() async {
    await _audioPlayer.stopPlayer();
    setState(() {
      isPlaying = false;
    });
  }

  void togglePauseRecording() {
    setState(() {
      isPaused = !isPaused;
    });
    log(isPaused ? 'Recording paused' : 'Recording resumed');
  }

  void onPlayButtonPressed() async {
    if (isPlaying) {
      await stopPlaying();
      setState(() {
        recordingDuration = Duration.zero;
      });
    } else {
      await playRecording();
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _thumbPosition += details.delta.dx;
      _thumbPosition = _thumbPosition.clamp(0.0, (_dotCount - 1) * _dotSpacing);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.deepNight : ChatifyColors.lightGrey,
        border: Border(top: BorderSide(color: context.isDarkMode ? ChatifyColors.darkBackground : ChatifyColors.grey, width: 1)),
      ),
      child: isRecording ? _buildRecordingUI(context) : _buildInputUI(context),
    );
  }

  Widget _buildInputUI(BuildContext context) {
    return Row(
      children: [
        _buildEmojiButton(context),
        SizedBox(width: 8),
        _buildAttachButton(context),
        Expanded(child: _buildTextField(context)),
        _buildVoiceMessageButton(context),
      ],
    );
  }

  Widget _buildEmojiButton(BuildContext context) {
    final hoverBackgroundColor = context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt());

    return CustomTooltip(
      verticalOffset: -70,
      horizontalOffset: -140,
      message: 'Смайлики, GIF-файлы, стикеры (Ctrl+Shift+E,G,S)',
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          onTap: () async {
            setState(() => isEmojiDialogOpen = true);

            await widget.showEmojiStickersDialog();

            setState(() => isEmojiDialogOpen = false);
          },
          mouseCursor: SystemMouseCursors.basic,
          borderRadius: BorderRadius.circular(8),
          splashFactory: NoSplash.splashFactory,
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
          hoverColor: hoverBackgroundColor,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: isEmojiDialogOpen ? hoverBackgroundColor : ChatifyColors.transparent, borderRadius: BorderRadius.circular(8)),
            child: Iconoir(Iconoir.emoji, width: 20, height: 20, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachButton(BuildContext context) {
    final hoverBackgroundColor = context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt());

    return CustomTooltip(
      verticalOffset: -70,
      horizontalOffset: -35,
      message: 'Прикрепить',
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          onTap: () async {
            setState(() => isAttachDialogOpen = true);

            await widget.showAttachFileDialog();

            setState(() => isAttachDialogOpen = false);
          },
          mouseCursor: SystemMouseCursors.basic,
          borderRadius: BorderRadius.circular(8),
          splashFactory: NoSplash.splashFactory,
          splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
          hoverColor: hoverBackgroundColor,
          child: Container(
            padding: EdgeInsets.all(11),
            decoration: BoxDecoration(color: isAttachDialogOpen ? hoverBackgroundColor : ChatifyColors.transparent, borderRadius: BorderRadius.circular(8)),
            child: Transform(
              transform: Matrix4.rotationZ(math.pi / 1),
              alignment: Alignment.center,
              child: Iconoir(Iconoir.attachment, width: 18, height: 18, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(widget.focusNode);
      },
      onSecondaryTapDown: (TapDownDetails details) {
        FocusScope.of(context).requestFocus(widget.focusNode);
        Future.delayed(Duration(milliseconds: 10), () {
          if (context.mounted) {
            showEditTextDialog(context, details.localPosition, widget.textController);
          }
        });
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Container(
          key: widget.textFieldKey,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.focusNode.hasFocus ? ChatifyColors.transparent : isHovered
              ? (context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt()) : ChatifyColors.softGrey.withAlpha((0.2 * 255).toInt()))
              : ChatifyColors.transparent,
          ),
          child: TextSelectionTheme(
            data: TextSelectionThemeData(
              cursorColor: colorsController.getColor(colorsController.selectedColorScheme.value),
              selectionColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.3 * 255).toInt()),
              selectionHandleColor: colorsController.getColor(colorsController.selectedColorScheme.value),
            ),
            child: TextField(
              controller: widget.textController,
              focusNode: widget.focusNode,
              cursorHeight: 19,
              contextMenuBuilder: (context, editableTextState) {
                return const SizedBox.shrink();
              },
              decoration: InputDecoration(
                hintText: 'Введите сообщение',
                hintStyle: TextStyle(
                  color: widget.focusNode.hasFocus ? ChatifyColors.steelGrey : (context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.darkGrey),
                  fontWeight: FontWeight.w300,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 6),
                filled: false,
              ),
              style: TextStyle(fontSize: ChatifySizes.fontSizeSm, fontWeight: FontWeight.w400),
              onSubmitted: (_) => widget.sendMessage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceMessageButton(BuildContext context) {
    return Tooltip(
      waitDuration: const Duration(milliseconds: 700),
      showDuration: const Duration(seconds: 700),
      verticalOffset: -50,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      message: 'Записать голосовое сообщение',
      textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
      decoration: BoxDecoration(
        color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
        boxShadow: [
          BoxShadow(
            color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: ChatifyColors.transparent,
        child: InkWell(
          onTap: () {
            if (hasText) {
              widget.sendMessage();
            } else {
              startRecording();
            }
          },
          mouseCursor: SystemMouseCursors.basic,
          splashColor: ChatifyColors.transparent,
          highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
          hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt()),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              hasText ? FluentIcons.send_16_regular : FluentIcons.mic_28_regular,
              size: 20,
              color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordingUI(BuildContext context) {
    String formattedDuration = '${recordingDuration.inMinutes}:${(recordingDuration.inSeconds % 60).toString().padLeft(2, '0')}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Tooltip(
          verticalOffset: -50,
          waitDuration: Duration(milliseconds: 800),
          exitDuration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          message: 'Удалить голосовое сообщение',
          textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
          decoration: BoxDecoration(
            color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.white.withAlpha((0.8 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              onTap: stopRecording,
              mouseCursor: SystemMouseCursors.basic,
              hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt()),
              splashColor: ChatifyColors.transparent,
              highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FluentIcons.delete_24_regular, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, size: 20),
              ),
            ),
          ),
        ),
        SizedBox(width: 14),
        if (!isPaused) BlinkAnimation(),
        if (isPaused)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: context.isDarkMode ? ChatifyColors.transparent : ChatifyColors.grey.withAlpha((0.4 * 255).toInt()),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: context.isDarkMode ? ChatifyColors.youngNight : ChatifyColors.grey),
          ),
          child: Row(
            children: [
              Material(
                color: ChatifyColors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                  mouseCursor: SystemMouseCursors.basic,
                  splashColor: ChatifyColors.transparent,
                  highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
                  hoverColor: ChatifyColors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                      color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                      size: isPlaying ? 26 : 26,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: _dotCount * (_dotSpacing + 0.1),
                height: 20,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(_dotCount, (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.3, vertical: 1),
                          child: Container(
                            width: 1.9,
                            height: 1.9,
                            decoration: BoxDecoration(color: ChatifyColors.darkGrey, shape: BoxShape.circle),
                          ),
                        )),
                      ),
                    ),
                    Positioned(
                      left: _thumbPosition,
                      top: 4,
                      child: GestureDetector(
                        onHorizontalDragUpdate: _onDragUpdate,
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(color: colorsController.getColor(colorsController.selectedColorScheme.value), shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 14),
              Text(formattedDuration, style: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: 15, fontWeight: FontWeight.w300, fontFamily: 'Roboto')),
              SizedBox(width: 4),
            ],
          ),
        ),
        if (!isPaused)
        SizedBox(width: 12),
        if (!isPaused)
        Text(formattedDuration, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
        if (!isPaused)
        SizedBox(width: 14),
        if (!isPaused)
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(17, (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.3, vertical: 1),
            child: Container(
              width: 1.9,
              height: 1.9,
              decoration: BoxDecoration(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.iconGrey, shape: BoxShape.circle),
            ),
          )),
        ),
        SizedBox(width: 12),
        Tooltip(
          verticalOffset: -50,
          waitDuration: Duration(milliseconds: 800),
          exitDuration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          message: isPaused ? 'Возобновить запись' : 'Приостановить',
          textStyle: TextStyle(color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontSize: ChatifySizes.fontSizeLm, fontWeight: FontWeight.w300),
          decoration: BoxDecoration(
            color: context.isDarkMode ? ChatifyColors.youngNight.withAlpha((0.8 * 255).toInt()) : ChatifyColors.white.withAlpha((0.8 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.isDarkMode ? ChatifyColors.darkBackground.withAlpha((0.7 * 255).toInt()) : ChatifyColors.buttonGrey, width: 1),
            boxShadow: [
              BoxShadow(
                color: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: ChatifyColors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  isPaused = !isPaused;
                });
              },
              mouseCursor: SystemMouseCursors.basic,
              splashColor: ChatifyColors.transparent,
              highlightColor: isPaused ? context.isDarkMode
                ? ChatifyColors.red.withAlpha((0.1 * 255).toInt()) : ChatifyColors.red.withAlpha((0.1 * 255).toInt())
                : context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.1 * 255).toInt()),
              hoverColor: isPaused
                ? context.isDarkMode ? ChatifyColors.red.withAlpha((0.1 * 255).toInt()) : ChatifyColors.red.withAlpha((0.1 * 255).toInt())
                : context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.4 * 255).toInt()) : ChatifyColors.darkerGrey.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  isPaused ? FluentIcons.mic_28_regular : PhosphorIcons.pause_light,
                  color: isPaused ? ChatifyColors.ascentRed : (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                  size: 21,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        CustomTooltip(
          message: 'Отправить голосовое сообщение',
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: colorsController.getColor(colorsController.selectedColorScheme.value)),
            child: Material(
              color: ChatifyColors.transparent,
              child: InkWell(
                onTap: () {
                  togglePauseRecording();
                },
                mouseCursor: SystemMouseCursors.basic,
                splashColor: ChatifyColors.transparent,
                highlightColor: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                hoverColor: ChatifyColors.black.withAlpha((0.2 * 255).toInt()),
                child: Padding(
                  padding: const EdgeInsets.all(11),
                  child: Icon(FluentIcons.send_16_regular, size: 18, color: ChatifyColors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
