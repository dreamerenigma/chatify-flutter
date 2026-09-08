import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/calls/screens/video/outgoing_video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_sounds.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../widgets/dialog/protected_enctyption_sheet_dialog.dart';
import '../../widgets/panels/call_control_panel.dart';
import '../add_participants_screen.dart';

class OutgoingAudioCallScreen extends StatefulWidget {
  final UserModel user;

  const OutgoingAudioCallScreen({super.key, required this.user});

  @override
  OutgoingAudioCallScreenState createState() => OutgoingAudioCallScreenState();
}

class OutgoingAudioCallScreenState extends State<OutgoingAudioCallScreen> {
  late AudioPlayer audioPlayer = AudioPlayer();
  bool isMuted = false;
  bool showNewContent = false;
  bool isExternalSpeaker = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _setEarpiece();
    _startRingingTone();
  }

  @override
  void dispose() {
    _stopRingingTone();
    audioPlayer.dispose();
    super.dispose();
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

  Future<void> playClickButton(AudioPlayer audioPlayer) async {
    try {
      await audioPlayer.play(AssetSource(ChatifySounds.endCallButton));
    } catch (e) {
      log('${S.of(context).errorPlayingSound}: $e');
    }
  }

  void _toggleMicrophone() {
    setState(() {
      isMuted = !isMuted;
    });

    if (isMuted) {
      audioPlayer.setVolume(0);
    } else {
      audioPlayer.setVolume(1);
    }
  }

  Future<void> _toggleSpeaker() async {
    final newValue = !isExternalSpeaker;

    try {
      await Helper.setSpeakerphoneOn(newValue);

      if (!mounted) return;

      setState(() {
        isExternalSpeaker = newValue;
      });
    } catch (e) {
      log('Error switching speaker: $e');
    }
  }

  Future<void> _setEarpiece() async {
    try {
      await Helper.setSpeakerphoneOn(false);

      if (mounted) {
        setState(() {
          isExternalSpeaker = false;
        });
      }
    } catch (e) {
      log('Error setting earpiece: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = context.isDarkMode ? ChatifyImages.chatBackgroundDark : ChatifyImages.chatBackgroundLight;

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover))),
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(backgroundColor: ChatifyColors.darkSlate, radius: 25, child: Icon(Icons.close_fullscreen, color: ChatifyColors.white)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, createPageRoute(AddParticipantsScreen()));
                      },
                      child: const CircleAvatar(backgroundColor: ChatifyColors.darkSlate, radius: 25, child: Icon(Icons.person_add_alt_1_rounded, color: ChatifyColors.white)),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${widget.user.name} ${widget.user.surname}', style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeMd, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 220,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lock_outline, color: ChatifyColors.darkGrey, size: 16),
                              Expanded(child: Text(S.of(context).protectedWithEndToEndEncryption, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey), textAlign: TextAlign.center)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(DeviceUtils.getScreenHeight(context) * .2),
                  child: CachedNetworkImage(
                    width: DeviceUtils.getScreenHeight(context) * .27,
                    height: DeviceUtils.getScreenHeight(context) * .27,
                    imageUrl: widget.user.image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      foregroundColor: ChatifyColors.white,
                      child: SvgPicture.asset(ChatifyVectors.profile, width: DeviceUtils.getScreenHeight(context) * .27, height: DeviceUtils.getScreenHeight(context) * .27),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CallControlPanel(
            isExternalSpeaker: isExternalSpeaker,
            isMuted: isMuted,

            onMore: () {
              showProtectedEncryptionBottomSheet(context);
            },

            onVideo: () async {
              final bool? shouldNavigate = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                    title: Text(S.of(context).switchToVideoCall, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.darkGrey, fontWeight: FontWeight.w400)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                    content: SizedBox(width: MediaQuery.of(context).size.width * 0.8, height: MediaQuery.of(context).size.width * 0.005),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ).copyWith(
                          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          splashFactory: NoSplash.splashFactory,
                          foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ).copyWith(
                          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(S.of(context).toggle, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                      ),
                    ],
                  );
                },
              );
              if (shouldNavigate == true && context.mounted) {
                Navigator.of(context).pushReplacement(createPageRoute(OutgoingVideoCallScreen(user: widget.user)));
              }
            },
            onSpeaker: _toggleSpeaker,
            onMicrophone: _toggleMicrophone,
            onShare: () {},
            onEndCall: () async {
              final navigator = Navigator.of(context);

              await playClickButton(audioPlayer);
              await _stopRingingTone();

              if (!mounted) return;

              navigator.pop();
            },
          ),
        ],
      ),
    );
  }
}
