import 'dart:developer';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:chatify/utils/constants/app_colors.dart';
import 'package:chatify/utils/constants/app_sounds.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:ionicons/ionicons.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/helper/file_util.dart';
import '../../../../utils/popups/custom_tooltip.dart';
import '../../../chat/models/user_model.dart';
import '../../../chat/widgets/dialogs/add_user_call_dialog.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../dialog/device_select_dialog.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

class OutgoingAudioCallWidget extends StatefulWidget {
  final UserModel user;

  const OutgoingAudioCallWidget({super.key, required this.user});

  @override
  State<OutgoingAudioCallWidget> createState() => _OutgoingAudioCallWidgetState();
}

class _OutgoingAudioCallWidgetState extends State<OutgoingAudioCallWidget> {
  late AudioPlayer audioPlayer = AudioPlayer();
  late String selectedCamera;
  late String selectedMicrophone;
  late String selectedSpeaker;
  bool isCallAccepted = false;
  bool isCallEnded = false;
  bool hasUserInteracted = false;
  bool isCalling = false;
  bool isArrowVideo = false;
  bool isArrowMicrophone= false;
  bool isVideoOn = false;
  bool isCameraOn = true;
  bool isMicOn = true;

  @override
  void initState() {
    super.initState();
    _initCameras();
    _startRingingTone();
    selectedMicrophone = '';
    selectedSpeaker = '';

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !isCallEnded) {
        setState(() {
          isCalling = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 8000), () {
      if (mounted && !isCallEnded && !hasUserInteracted) {
        _stopRingingTone();
        setState(() {
          isCallEnded = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.pop(context);
        });
      }
    });
  }

  @override
  void dispose() {
    _stopRingingTone();
    audioPlayer.dispose();
    super.dispose();
  }

  void _onCallEndedByUser() {
    hasUserInteracted = true;

    _stopRingingTone();

    setState(() {
      isCallEnded = true;
    });

    Future.delayed(const Duration(seconds: 80), () {
      if (mounted && isCallEnded) {
        Navigator.pop(context);
      }
    });
  }

  void _restartCall() {
    setState(() {
      isCallEnded = false;
      hasUserInteracted = false;
      isCalling = false;
    });

    _startRingingTone();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !isCallEnded) {
        setState(() {
          isCalling = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && !isCallEnded && !hasUserInteracted) {
        _stopRingingTone();
        setState(() {
          isCallEnded = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.pop(context);
        });
      }
    });
  }

  Future<void> _initCameras() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        selectedCamera = cameras.first.name;
      });
    }
  }

  Future<List<webrtc.MediaDeviceInfo>> getAvailableMicrophones() async {
    final devices = await webrtc.navigator.mediaDevices.enumerateDevices();
    return devices.where((d) => d.kind == 'audioinput').toList();
  }

  Future<List<String>> getAvailableSpeakers() async {
    final devices = await webrtc.navigator.mediaDevices.enumerateDevices();
    final speakerDevices = devices.where((d) => d.kind == 'audiooutput').map((d) => d.label.isNotEmpty ? d.label : '${S.of(context).speaker} (${d.deviceId})').toList();

    return speakerDevices;
  }

  Future<void> _startRingingTone() async {
    try {
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.play(AssetSource(ChatifySounds.cellPhoneRing));
    } catch (e) {
      log('${S.of(context).errorStartingRingingTone}: $e');
    }
  }

  Future<void> _stopRingingTone() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      log('${S.of(context).errorStopingRingingTone}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = context.isDarkMode ? ChatifyImages.callBackgroundDark : ChatifyImages.groupBackgroundLight;

    return Scaffold(
      backgroundColor: ChatifyColors.blackGrey,
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ChatifyColors.black, width: 1.5),
                  image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.grey, width: 1)),
                            child: CircleAvatar(
                              radius: 43,
                              backgroundColor: context.isDarkMode ? ChatifyColors.softNight : ChatifyColors.lightGrey,
                              child: widget.user.image.isNotEmpty
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: widget.user.image,
                                      placeholder: (context, url) => CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colorsController.getColor(colorsController.selectedColorScheme.value))),
                                      errorWidget: (context, url, error) => Icon(Icons.error, size: 30),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  )
                                : SvgPicture.asset(ChatifyVectors.newUser, color: context.isDarkMode ? ChatifyColors.darkGrey : ChatifyColors.iconGrey, width: 42, height: 42, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(widget.user.name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black)),
                          const SizedBox(height: 8),
                          Text(
                            isCallEnded ? S.of(context).callEnded: isCalling ? '${S.of(context).call}...' : S.of(context).connected,
                            style: TextStyle(fontSize: ChatifySizes.fontSizeBg, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    if (isCallEnded)
                    Positioned(bottom: 24, left: 0, right: 0, child: _buildCallEnded()),
                  ],
                ),
              ),
            ),
            if (!isCallEnded) const SizedBox(height: 2),
            if (!isCallEnded) _buildBottomSettingsCall(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSettingsCall() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCircleButton(
                HeroIcon(HeroIcons.videoCameraSlash, style: HeroIconStyle.outline, color: isCameraOn ? (context.isDarkMode ? ChatifyColors.black : ChatifyColors.white) : (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black), size: 24),
                backgroundColor: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                arrowColor: context.isDarkMode ? ChatifyColors.black : ChatifyColors.white,
                iconHoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                onIconTap: () {
                  if (isCameraOn) {
                    setState(() {
                      isVideoOn = !isVideoOn;
                    });
                  }
                },
                onArrowTap: () async {
                  setState(() {
                    isArrowVideo = true;
                  });
                  await Future.delayed(const Duration(milliseconds: 150));
                  setState(() {
                    isArrowVideo = false;
                  });
                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  final cameras = await availableCameras();
                  if (cameras.isEmpty) return;

                  await showDeviceSelectDialog(
                    context: context,
                    position: position,
                    title: S.of(context).camera,
                    devices: cameras.map((c) => c.name).toList(),
                    nameFormatter: FileUtil.cleanDeviceName,
                    selectedDevice: selectedCamera,
                    onDeviceSelected: (device) {
                      setState(() {
                        selectedCamera = device;
                      });
                    },
                    showSpeakerSection: false,
                    showDefaultDeviceText: false,
                  );
                },
                message: S.of(context).turnOnCamera,
                isArrowEnabled: isArrowVideo,
              ),
              const SizedBox(width: 10),
              _buildCircleButton(
                Icon(isMicOn ? FluentIcons.mic_28_regular : FluentIcons.mic_off_28_regular, color: isMicOn ? (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black) : (context.isDarkMode ? ChatifyColors.black : ChatifyColors.white), size: 18),
                backgroundColor: isMicOn ? (context.isDarkMode ? ChatifyColors.mildNight : ChatifyColors.mildNight) : (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                arrowColor: isMicOn ? (context.isDarkMode ? ChatifyColors.white : ChatifyColors.black) : (context.isDarkMode ? ChatifyColors.black : ChatifyColors.white),
                iconHoverColor: context.isDarkMode ? ChatifyColors.darkGrey.withAlpha((0.5 * 255).toInt()) : ChatifyColors.grey,
                onIconTap: () {
                  setState(() {
                    isMicOn = !isMicOn;
                  });
                },
                onArrowTap: () async {
                  setState(() {
                    isArrowMicrophone = true;
                  });
                  await Future.delayed(const Duration(milliseconds: 150));
                  setState(() {
                    isArrowMicrophone = false;
                  });
                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                  final position = renderBox.localToGlobal(Offset.zero);
                  final microphones = await getAvailableMicrophones();
                  final microphoneLabels = microphones.map((device) {
                    return device.label.isNotEmpty ? device.label : '${S.of(context).microphone} (${device.deviceId})';
                  }).toList();
                  final List<String> speakers = await getAvailableSpeakers();
                  final speakerLabels = speakers.map((name) {
                    final trimmed = name.trim();
                    return trimmed.isNotEmpty ? trimmed : S.of(context).speaker;
                  }).toList();

                  if (microphoneLabels.isEmpty) return;

                  if (selectedMicrophone.isEmpty) {
                    selectedMicrophone = 'default';
                  }
                  if (selectedSpeaker.isEmpty) {
                    selectedSpeaker = 'default';
                  }

                  await showDeviceSelectDialog(
                    context: context,
                    position: position,
                    title: S.of(context).microphone,
                    devices: microphoneLabels,
                    speakerDevices: speakerLabels,
                    nameFormatter: FileUtil.cleanDeviceName,
                    selectedDevice: selectedMicrophone,
                    selectedSpeakerDevice: selectedSpeaker,
                    dialogWidth: 290,
                    onDeviceSelected: (device) {
                      if (device.trim().isEmpty) {
                        log(S.of(context).warningEmptyMicrophoneSelected);
                      }
                      setState(() {
                        selectedMicrophone = device;
                      });
                    },
                    onSpeakerSelected: (device) {
                      if (device.trim().isEmpty) {
                        log(S.of(context).warningEmptySpeakerSelected);
                      }
                      setState(() {
                        selectedSpeaker = device;
                      });
                    },
                  );
                },
                isArrowEnabled: isArrowMicrophone,
                message: isMicOn ? S.of(context).turnOffMicrophone : S.of(context).turnOnMicrophone,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconButton(
                icon: SvgPicture.asset(ChatifyVectors.demonstrationScreen, width: 23, height: 23, color: ChatifyColors.white),
                message: S.of(context).shareScreen,
                onTap: () {},
                isEnabled: isCallAccepted,
              ),
              const SizedBox(width: 4),
              _buildIconButton(
                icon: SvgPicture.asset(ChatifyVectors.addCallUser, width: 26, height: 26, color: ChatifyColors.white),
                message: S.of(context).addParticipants,
                tooltipOffsetX: -65,
                onTap: () {
                  final Size screenSize = MediaQuery.of(context).size;
                  final double topOffset = 16;
                  final double rightOffset = 16;
                  final Offset position = Offset(screenSize.width - 290 - rightOffset, topOffset);

                  showAddUserCallDialog(context, position);
                }
              ),
              const SizedBox(width: 4),
              _buildIconButton(
                icon: SvgPicture.asset(ChatifyVectors.text, width: 15, height: 15, color: ChatifyColors.white),
                message: S.of(context).openChat,
                tooltipOffsetX: -40,
                padding: 17,
                onTap: () {},
              ),
            ],
          ),
          _buildCircleEndCallButton(),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required Widget icon,
    required String message,
    required VoidCallback? onTap,
    bool isEnabled = true,
    double padding = 12,
    double opacityDisabled = 0.4,
    double tooltipOffsetX = -45,
    double tooltipOffsetY = -70,
  }) {
    final inkWell = InkWell(
      onTap: isEnabled ? onTap : null,
      mouseCursor: SystemMouseCursors.basic,
      borderRadius: BorderRadius.circular(12),
      splashFactory: NoSplash.splashFactory,
      splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
      child: Opacity(opacity: isEnabled ? 1.0 : opacityDisabled, child: Padding(padding: EdgeInsets.all(padding), child: icon)),
    );

    if (!isEnabled) {
      return inkWell;
    }

    return CustomTooltip(
      message: message,
      verticalOffset: tooltipOffsetY,
      horizontalOffset: tooltipOffsetX,
      child: inkWell,
    );
  }

  Widget _buildCallEnded() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildEndCallButton(ChatifyVectors.text, S.of(context).message, () {
          Navigator.pop(context);
        }),
        const SizedBox(width: 100),
        _buildEndCallButton(ChatifyVectors.calls, S.of(context).callBack, () {
          _restartCall();
        },
        backgroundColor: ChatifyColors.green),
        const SizedBox(width: 110),
        _buildEndCallButton(Ionicons.close_outline, S.of(context).close, () {
          Navigator.pop(context);
        }),
      ],
    );
  }

  Widget _buildEndCallButton(dynamic iconData, String label, VoidCallback? onTap, {Color? backgroundColor}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: ChatifyColors.transparent,
          child: InkWell(
            onTap: onTap,
            mouseCursor: SystemMouseCursors.basic,
            borderRadius: BorderRadius.circular(30),
            splashFactory: NoSplash.splashFactory,
            splashColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            highlightColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            hoverColor: context.isDarkMode ? ChatifyColors.darkerGrey.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
            child: Ink(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: backgroundColor ?? (context.isDarkMode ? ChatifyColors.buttonSecondaryDark : ChatifyColors.grey), shape: BoxShape.circle),
              child: iconData is String
                ? SizedBox(
                  width: 18,
                  height: 18,
                  child: SvgPicture.asset(iconData, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fit: BoxFit.scaleDown, alignment: Alignment.center),
                )
                : Icon(iconData, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 15, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, fontWeight: FontWeight.w300)),
      ],
    );
  }

  Widget _buildCircleButton(
    Widget icon, {
    Color backgroundColor = ChatifyColors.white,
    bool showArrow = true,
    Color arrowColor = ChatifyColors.black,
    Color? iconHoverColor,
    VoidCallback? onIconTap,
    VoidCallback? onArrowTap,
    required String message,
    required bool isArrowEnabled,
  }) {
    ValueNotifier<bool> isIconHovered = ValueNotifier(false);
    ValueNotifier<bool> isArrowHovered = ValueNotifier(false);

    return CustomTooltip(
      message: message,
      verticalOffset: -70,
      horizontalOffset: -45,
      child: Container(
        height: 38,
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MouseRegion(
              onEnter: (_) => isIconHovered.value = true,
              onExit: (_) => isIconHovered.value = false,
              child: ValueListenableBuilder<bool>(
                valueListenable: isIconHovered,
                builder: (_, hover, __) {
                  return Material(
                    color: ChatifyColors.transparent,
                    child: InkWell(
                      onTap: onIconTap,
                      mouseCursor: SystemMouseCursors.basic,
                      splashColor: ChatifyColors.transparent,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                      highlightColor: iconHoverColor,
                      hoverColor: iconHoverColor,
                      child: Container(
                        width: 33,
                        height: 38,
                        decoration: BoxDecoration(color: hover ? backgroundColor.withAlpha((0.2 * 255).toInt()) : ChatifyColors.transparent, borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: icon,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (showArrow) ...[
              MouseRegion(
                onEnter: (_) => isArrowHovered.value = true,
                onExit: (_) => isArrowHovered.value = false,
                child: ValueListenableBuilder<bool>(
                  valueListenable: isArrowHovered,
                  builder: (_, hover, __) {
                    return Material(
                      color: ChatifyColors.transparent,
                      child: InkWell(
                        onTap: onArrowTap,
                        mouseCursor: SystemMouseCursors.basic,
                        splashColor: ChatifyColors.transparent,
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                        highlightColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        hoverColor: context.isDarkMode ? ChatifyColors.lightSoftNight.withAlpha((0.3 * 255).toInt()) : ChatifyColors.grey,
                        child: Container(
                          width: 28,
                          height: 38,
                          decoration: BoxDecoration(color: hover ? arrowColor.withAlpha((0.2 * 255).toInt()) : ChatifyColors.transparent, borderRadius: const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            transform: Matrix4.translationValues(0, isArrowEnabled ? 2 : 0, 0),
                            child: SvgPicture.asset(ChatifyVectors.arrowDown, width: 17, height: 17, color: arrowColor),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCircleEndCallButton() {
    return CustomTooltip(
      message: S.of(context).finish,
      verticalOffset: -70,
      horizontalOffset: -45,
      child: InkWell(
        onTap: _onCallEndedByUser,
        mouseCursor: SystemMouseCursors.basic,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 65,
          height: 38,
          decoration: BoxDecoration(color: ChatifyColors.ascentRed, borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: math.pi / 1.34,
                child: SvgPicture.asset(ChatifyVectors.calls, color: ChatifyColors.white, width: 21, height: 21),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
