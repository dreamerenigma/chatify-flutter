import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_sounds.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../widgets/dialog/message_audio_call_dialog.dart';

class IncomingAudioCallScreen extends StatefulWidget {
  final UserModel user;
  const IncomingAudioCallScreen({super.key, required this.user});

  @override
  State<IncomingAudioCallScreen> createState() => _IncomingAudioCallScreenState();
}

class _IncomingAudioCallScreenState extends State<IncomingAudioCallScreen> {
  late AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playClickButton(AudioPlayer audioPlayer) async {
    try {
      log('Playing sound...');
      await audioPlayer.play(AssetSource(ChatifySounds.endCallButton));
      log('Sound played successfully.');
    } catch (e) {
      log('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImage = context.isDarkMode ? ChatifyImages.chatBackgroundDark : ChatifyImages.chatBackgroundLight;

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage(backgroundImage), fit: BoxFit.cover))),
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.user.name, style: TextStyle(fontSize: ChatifySizes.fontSizeMg)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage(ChatifyImages.appLogoLight), width: 16, color: ChatifyColors.darkGrey),
                  const SizedBox(width: 6),
                  Text(widget.user.phoneNumber, style: TextStyle(fontSize: ChatifySizes.fontSizeLg, color: ChatifyColors.darkGrey),
                  ),
                ],
              ),
              const Spacer(),
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
                          foregroundColor: colorsController.getColor(colorsController.selectedColorScheme.value),
                          child: SvgPicture.asset(ChatifyVectors.profile),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ElevatedButton(
                              onPressed: () async {
                                await playClickButton(audioPlayer);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: ChatifyColors.error,
                                minimumSize: const Size(60, 60),
                                side: BorderSide.none,
                              ),
                              child: const Icon(Icons.call_end_rounded, color: ChatifyColors.white, size: 30),
                            ),
                          ),
                          Text('Отклонить', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: ChatifyColors.green,
                                minimumSize: const Size(60, 60),
                                side: BorderSide.none,
                              ),
                              child: const Icon(Icons.call_rounded, color: ChatifyColors.white, size: 30),
                            ),
                          ),
                          Text('Проведите вверх,\nчтобы принять', textAlign: TextAlign.center, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const MessageAudioCallDialog();
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: ChatifyColors.blackGrey,
                                minimumSize: const Size(60, 60),
                                side: BorderSide.none,
                              ),
                              child: const Icon(Icons.message_outlined, color: ChatifyColors.white, size: 30),
                            ),
                          ),
                          Text('Сообщение', style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeSm)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
