import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/calls/screens/video/outgoing_video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
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
import '../add_participants_screen.dart';

class OutgoingAudioCallScreen extends StatefulWidget {
  final UserModel user;

  const OutgoingAudioCallScreen({super.key, required this.user});

  @override
  OutgoingAudioCallScreenState createState() => OutgoingAudioCallScreenState();
}

class OutgoingAudioCallScreenState extends State<OutgoingAudioCallScreen> {
  bool isMuted = false;
  bool showNewContent = false;
  bool isExternalSpeaker = false;
  late AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
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

  void _toggleSpeaker() {
    setState(() {
      isExternalSpeaker = !isExternalSpeaker;
    });

    if (isExternalSpeaker) {
      audioPlayer.setVolume(1);
    } else {
      audioPlayer.setVolume(0);
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
                        Text(widget.user.name, style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: ChatifyColors.white)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_outline, color: ChatifyColors.darkGrey, size: 16),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 220,
                              child: Text(S.of(context).protectedWithEndToEndEncryption,
                                style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
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
                    width: DeviceUtils.getScreenHeight(context) * .25,
                    height: DeviceUtils.getScreenHeight(context) * .25,
                    imageUrl: widget.user.image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                      foregroundColor: ChatifyColors.white,
                      child: SvgPicture.asset(ChatifyVectors.profile),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: ChatifyColors.black.withAlpha((0.1 * 255).toInt()),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: ChatifyColors.darkSlate,
                        radius: 25,
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz_rounded, color: ChatifyColors.white, size: 30),
                          onPressed: () => showProtectedEncryptionBottomSheet(context),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          bool? shouldNavigate = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: context.isDarkMode ? ChatifyColors.blackGrey : ChatifyColors.white,
                                title: Text(S.of(context).switchToVideoCall, style: TextStyle(fontSize: ChatifySizes.fontSizeSm, color: ChatifyColors.darkGrey)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                                content: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.width * 0.005,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                    child: Text(
                                      S.of(context).cancel,
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                                      backgroundColor: colorsController.getColor(colorsController.selectedColorScheme.value).withAlpha((0.1 * 255).toInt()),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                    child: Text(
                                      S.of(context).toggle,
                                      style: TextStyle(fontSize: ChatifySizes.fontSizeMd, color: colorsController.getColor(colorsController.selectedColorScheme.value)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldNavigate == true) {
                            Navigator.push(context, createPageRoute(OutgoingVideoCallScreen(user: APIs.me)));
                          }
                        },
                        child: const CircleAvatar(
                          backgroundColor: ChatifyColors.darkSlate,
                          radius: 25,
                          child: Icon(Icons.videocam_rounded, color: ChatifyColors.white, size: 30),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: isExternalSpeaker ? ChatifyColors.white : ChatifyColors.darkSlate,
                        radius: 25,
                        child: IconButton(
                          icon: Icon(Icons.volume_up, color: isExternalSpeaker ? ChatifyColors.black : ChatifyColors.white, size: 30),
                          onPressed: _toggleSpeaker,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: ChatifyColors.darkSlate,
                        radius: 25,
                        child: IconButton(
                          icon: Icon(isMuted ? Icons.mic : Icons.mic_off, color: ChatifyColors.white, size: 30),
                          onPressed: _toggleMicrophone,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await playClickButton(audioPlayer);
                          _stopRingingTone();
                          Navigator.pop(context);
                        },
                        child: const CircleAvatar(backgroundColor: ChatifyColors.error, radius: 25, child: Icon(Icons.call_end, color: ChatifyColors.white, size: 30)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
