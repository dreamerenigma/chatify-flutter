import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_images.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_sounds.dart';
import '../../chat/models/user_model.dart';
import '../widgets/dialog/time_remaining_dialog.dart';
import '../widgets/dialog/waiting_other_participant_sheet_dialog.dart';
import 'create_link_call_screen.dart';

class LinkAudioScreen extends StatefulWidget {
  final UserModel user;
  final String linkToSend;

  const LinkAudioScreen({super.key, required this.linkToSend, required this.user});

  @override
  LinkAudioScreenState createState() => LinkAudioScreenState();
}

class LinkAudioScreenState extends State<LinkAudioScreen> {
  Timer? _timer;
  bool _showNewContent = false;
  late AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _timer = Timer(const Duration(minutes: 10), () {
      if (mounted) {
        showTimeRemainingDialog(context);
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> playClickButton(AudioPlayer audioPlayer) async {
    try {
      await audioPlayer.play(AssetSource(ChatifySounds.endCallButton));
    } catch (e) {
      log('${S.of(context).errorPlayingSound}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = context.isDarkMode ? ChatifyImages.chatBackgroundDark : ChatifyImages.chatBackgroundLight;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover)),
          ),
          if (!_showNewContent) ...[
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.user.name, style: TextStyle(fontSize: ChatifySizes.fontSizeMg, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16.0),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage(ChatifyImages.appLogoLight), width: 16, color: ChatifyColors.darkGrey),
                    const SizedBox(width: 6),
                    Text(S.of(context).callLink, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: ChatifyColors.darkGrey)),
                  ],
                ),
                const Spacer(),
                Padding(
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
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(context, createPageRoute(CreateLinkCallScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: ChatifyColors.black,
                                backgroundColor: ChatifyColors.darkerGrey,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                side: BorderSide.none,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              ),
                              child: Text(
                                S.of(context).skip,
                                style: TextStyle(fontWeight: FontWeight.w500, color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showNewContent = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                side: BorderSide.none,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              ),
                              child: Text(
                                S.of(context).join,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: context.isDarkMode ? ChatifyColors.white : ChatifyColors.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(radius: 25, backgroundColor: ChatifyColors.darkerGrey, child: Icon(Icons.close_fullscreen, color: ChatifyColors.white)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child: Text(S.of(context).appCall, style: TextStyle(fontSize: ChatifySizes.fontSizeBg, fontWeight: FontWeight.bold, color: ChatifyColors.white)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              showWaitingParticipantBottomSheetDialog(context);
                            },
                            child: const CircleAvatar(radius: 25, backgroundColor: ChatifyColors.darkerGrey, child: Icon(Icons.group, color: ChatifyColors.white)),
                          ),
                        ],
                      ),
                      Text(S.of(context).waitingOtherParticipants, style: TextStyle(fontSize: 16, color: Colors.white70)),
                    ],
                  ),
                ),
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
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const CircleAvatar(backgroundColor: ChatifyColors.darkerGrey, radius: 25, child: Icon(Icons.more_horiz_rounded, color: ChatifyColors.white)),
                        const CircleAvatar(backgroundColor: ChatifyColors.darkerGrey, radius: 25, child: Icon(Icons.volume_up, color: ChatifyColors.white)),
                        const CircleAvatar(backgroundColor: ChatifyColors.darkerGrey, radius: 25, child: Icon(Icons.mic, color: ChatifyColors.white)),
                        InkWell(
                          onTap: () async {
                            await playClickButton(audioPlayer);
                            Navigator.pop(context);
                          },
                          child: const CircleAvatar(
                            backgroundColor: ChatifyColors.error,
                            radius: 25,
                            child: Icon(Icons.call_end, color: ChatifyColors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
