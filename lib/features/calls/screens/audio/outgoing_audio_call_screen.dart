import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatify/features/calls/screens/video/outgoing_video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../config/config.dart';
import '../../../../core/enums/call_state_type.dart';
import '../../../../core/enums/call_status_type.dart';
import '../../../../core/enums/call_type.dart';
import '../../../../core/services/calls/agora_call_service.dart';
import '../../../../core/services/calls/agora_token_service.dart';
import '../../../../core/services/calls/call_service.dart';
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
import '../../models/call_model.dart';
import '../../models/call_result.dart';
import '../../widgets/dialog/protected_enctyption_sheet_dialog.dart';
import '../../widgets/panels/call_control_panel.dart';
import '../add_participants_screen.dart';

class OutgoingAudioCallScreen extends StatefulWidget {
  final UserModel user;
  final VoidCallback? onMinimize;

  const OutgoingAudioCallScreen({
    super.key,
    required this.user,
    required this.onMinimize,
  });

  @override
  OutgoingAudioCallScreenState createState() => OutgoingAudioCallScreenState();
}

class OutgoingAudioCallScreenState extends State<OutgoingAudioCallScreen> {
  final CallService _callService = Get.find<CallService>();
  final AgoraCallService _agoraCallService = Get.find<AgoraCallService>();
  late AudioPlayer audioPlayer = AudioPlayer();
  bool isMuted = false;
  bool showNewContent = false;
  bool isExternalSpeaker = false;
  String? _callId;
  StreamSubscription<CallModel>? _callSubscription;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _startRingingTone();
    _startCall();
  }

  @override
  void dispose() {
    _stopRingingTone();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startCall() async {
    try {
      log('[OUTGOING_AUDIO] 1. startCall()', name: 'OutgoingAudioCallScreen');

      final callId = await _callService.startCall(widget.user);

      _callId = callId;

      log('[OUTGOING_AUDIO] 2. call created: $callId', name: 'OutgoingAudioCallScreen');

      log('[OUTGOING_AUDIO] 3. prepareAgora()', name: 'OutgoingAudioCallScreen');

      await prepareAgora();

      log('[OUTGOING_AUDIO] 4. Agora prepared', name: 'OutgoingAudioCallScreen');

      log('[OUTGOING_AUDIO] 5. joinChannel(call_$callId)', name: 'OutgoingAudioCallScreen');

      final channelName = 'call_$callId';
      final token = await AgoraTokenService.fetchToken(channelName: channelName, uid: 0);

      await _agoraCallService.joinChannel(channelName: channelName, token: token);

      log('[OUTGOING_AUDIO] 6. Agora join requested', name: 'OutgoingAudioCallScreen');

      if (!mounted) return;

      _listenCall(callId);
    } catch (e, stackTrace) {
      log('[OUTGOING_AUDIO] ❌ START CALL ERROR: $e', name: 'OutgoingAudioCallScreen', error: e, stackTrace: stackTrace);

      if (!mounted) return;

      await _stopRingingTone();

      Navigator.pop(context, CallResult(type: CallType.audio, status: CallStatusType.noAnswer));
    }
  }

  // Future<void> _startCall() async {
  //   try {
  //     final callId = await _callService.startCall(widget.user);
  //
  //     _callId = callId;
  //
  //     _listenCall(callId);
  //   } catch (e) {
  //     if (!mounted) return;
  //
  //     await _stopRingingTone();
  //
  //     Navigator.pop(context, CallResult(type: CallType.audio, status: CallStatusType.noAnswer));
  //   }
  // }

  Future<void> prepareAgora() async {
    await _agoraCallService.initialize(appId: Config.appId);
  }

  Future<void> _toggleSpeaker() async {
    log('[OUTGOING_AUDIO] 🔊 Toggle speaker', name: 'OutgoingAudioCallScreen');

    final newState = !isExternalSpeaker;

    log('[OUTGOING_AUDIO] Current: $isExternalSpeaker', name: 'OutgoingAudioCallScreen');

    log('[OUTGOING_AUDIO] Request new state: $newState', name: 'OutgoingAudioCallScreen');

    final success =
    await _agoraCallService.setSpeakerphone(newState);

    if (!mounted) return;

    if (!success) {
      log('[OUTGOING_AUDIO] ❌ Speaker switch failed', name: 'OutgoingAudioCallScreen');

      return;
    }

    setState(() {
      isExternalSpeaker = newState;
    });

    log('[OUTGOING_AUDIO] ✅ UI state updated: $isExternalSpeaker', name: 'OutgoingAudioCallScreen');
  }

  Future<void> _finishCall(CallStatusType status) async {
    await _stopRingingTone();

    await _callSubscription?.cancel();
    _callSubscription = null;

    if (!mounted) return;

    Navigator.pop(context, CallResult(type: CallType.audio, status: status));
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

  void _listenCall(String callId) {
    log('[OUTGOING_AUDIO] Listening call: $callId', name: 'OutgoingAudioCallScreen');

    _callSubscription = _callService.observeCall(callId).listen((call) async {
      log('[OUTGOING_AUDIO] Call state: ${call.state.name}', name: 'OutgoingAudioCallScreen');
      switch (call.state) {
        case CallStateType.ringing:
          break;
        case CallStateType.accepted:
          log('[OUTGOING_AUDIO] Call accepted', name: 'OutgoingAudioCallScreen');
          break;
        case CallStateType.rejected:
          log('[OUTGOING_AUDIO] Call rejected', name: 'OutgoingAudioCallScreen');
          await _finishCall(CallStatusType.rejected);
          break;
        case CallStateType.ended:
          log('[OUTGOING_AUDIO] Call ended', name: 'OutgoingAudioCallScreen');
          await _finishCall(CallStatusType.noAnswer);
          break;
      }
    });
  }

  Future<void> _toggleMicrophone() async {
    final newMutedState = !isMuted;

    setState(() {
      isMuted = newMutedState;
    });

    final agoraCallService = Get.find<AgoraCallService>();

    await agoraCallService.mute(newMutedState);
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: ChatifyColors.darkSlate,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          widget.onMinimize?.call();
                          Navigator.of(context).pop();
                        },
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: SvgPicture.asset(
                              ChatifyVectors.resize,
                              width: 26,
                              height: 26,
                              colorFilter: ColorFilter.mode(context.isDarkMode ? ChatifyColors.white : ChatifyColors.black, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Icon(
                                    Icons.lock_outline,
                                    color: ChatifyColors.white,
                                    size: 14,
                                    shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color.fromARGB(128, 0, 0, 0))],
                                  ),
                                ),
                                const WidgetSpan(child: SizedBox(width: 4)),
                                TextSpan(
                                  text: S.of(context).protectedWithEndToEndEncryption,
                                  style: TextStyle(
                                    color: ChatifyColors.grey,
                                    fontSize: ChatifySizes.fontSizeSm,
                                    fontWeight: FontWeight.w400,
                                    shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color.fromARGB(128, 0, 0, 0))],
                                    height: 1.4
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
            isVideoEnabled: false,
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

              navigator.pop(CallResult(type: CallType.audio, status: CallStatusType.noAnswer));
            },
          ),
        ],
      ),
    );
  }
}
