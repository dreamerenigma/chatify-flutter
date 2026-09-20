import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
import '../../../../utils/constants/app_images.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_sounds.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/devices/device_utility.dart';
import '../../../chat/models/user_model.dart';
import '../../../personalization/widgets/dialogs/light_dialog.dart';
import '../../models/call_model.dart';
import '../../models/call_result.dart';
import '../../widgets/dialog/message_audio_call_dialog.dart';
import '../../widgets/dialog/protected_enctyption_sheet_dialog.dart';
import '../../widgets/panels/call_control_panel.dart';
import '../../widgets/panels/incoming_call_control_panel.dart';
import '../video/outgoing_video_call_screen.dart';

class IncomingAudioCallScreen extends StatefulWidget {
  final CallModel call;
  final UserModel user;

  const IncomingAudioCallScreen({
    super.key,
    required this.call,
    required this.user,
  });

  @override
  State<IncomingAudioCallScreen> createState() => _IncomingAudioCallScreenState();
}

class _IncomingAudioCallScreenState extends State<IncomingAudioCallScreen> {
  final CallService _callService = Get.find<CallService>();
  final AgoraCallService _agoraCallService = Get.find<AgoraCallService>();
  late AudioPlayer audioPlayer = AudioPlayer();
  bool isMuted = false;
  bool _isCallAccepted = false;
  bool isExternalSpeaker = false;

  @override
  void initState() {
    super.initState();
    AgoraTokenService.testServer();
    audioPlayer = AudioPlayer();
    prepareAgora();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playClickButton(AudioPlayer audioPlayer) async {
    try {
      await audioPlayer.play(AssetSource(ChatifySounds.endCallButton));
    } catch (e) {
      log('${S.of(context).errorPlayingSound}: $e');
    }
  }

  Future<void> _stopRingingTone() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      log('${S.of(context).errorStopingRingingTone}: $e');
    }
  }

  Future<void> _acceptCall() async {
    try {
      await playClickButton(audioPlayer);

      final call = await _callService.getCall(widget.call.id);

      if (call == null) {
        log('[INCOMING_AUDIO] ❌ Call no longer exists', name: 'IncomingAudioCallScreen');

        if (mounted) {
          Navigator.of(context).pop(CallResult(type: CallType.audio, status: CallStatusType.noAnswer));
        }

        return;
      }

      if (call.state != CallStateType.ringing) {
        log('[INCOMING_AUDIO] ⚠️ Call is no longer ringing: ${call.state}', name: 'IncomingAudioCallScreen');

        if (mounted) {
          Navigator.of(context).pop(CallResult(type: CallType.audio, status: CallStatusType.noAnswer));
        }

        return;
      }

      await _callService.acceptCall(widget.call.id);
      await prepareAgora();

      final channelName = widget.call.channelName;

      log('[INCOMING_AUDIO] 🔵 Request Agora token ''channel=$channelName', name: 'IncomingAudioCallScreen');

      final token = await AgoraTokenService.fetchToken(channelName: channelName, uid: 0);

      log('[INCOMING_AUDIO] 🟢 Agora token received', name: 'IncomingAudioCallScreen');

      await _agoraCallService.joinChannel(channelName: channelName, token: token);

      log('[INCOMING_AUDIO] 🟢 Agora join requested ''channel=$channelName', name: 'IncomingAudioCallScreen');

      await _stopRingingTone();

      if (!mounted) return;

      setState(() {
        _isCallAccepted = true;
      });

      log('[INCOMING_AUDIO] 🟢 Call UI switched to active call', name: 'IncomingAudioCallScreen');
    } catch (e, st) {
      log('[INCOMING_AUDIO] ❌ Error accepting call: $e', name: 'IncomingAudioCallScreen', error: e, stackTrace: st);

      try {
        await _callService.endCall(widget.call.id);

        log('[INCOMING_AUDIO] 🔴 Call ended after accept error ''id=${widget.call.id}', name: 'IncomingAudioCallScreen');
      } catch (endError, endStackTrace) {
        log('[INCOMING_AUDIO] ❌ Failed to end call: $endError', name: 'IncomingAudioCallScreen', error: endError, stackTrace: endStackTrace);
      }

      await _agoraCallService.leaveChannel();

      if (!mounted) return;

      Navigator.of(context).pop(CallResult(type: CallType.audio, status: CallStatusType.noAnswer));
    }
  }

  Future<void> _rejectCall() async {
    try {
      await playClickButton(audioPlayer);
      await _callService.rejectCall(widget.call.id);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e, st) {
      log('Error rejecting call: $e');
      log('$st');
    }
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

  Future<void> prepareAgora() async {
    await _agoraCallService.initialize(appId: Config.appId);
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
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
              Text('${widget.user.name} ${widget.user.surname}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(ChatifyVectors.appLogoLight, width: 16, height: 16, colorFilter: const ColorFilter.mode(ChatifyColors.darkGrey, BlendMode.srcIn)),
                  const SizedBox(width: 6),
                  Text(widget.user.phoneNumber, style: TextStyle(color: ChatifyColors.darkGrey, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400)),
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
                          child: SvgPicture.asset(ChatifyVectors.profile, width: DeviceUtils.getScreenHeight(context) * .25, height: DeviceUtils.getScreenHeight(context) * .25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _isCallAccepted
                ? CallControlPanel(
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
                                onPressed: () => Navigator.pop(context),
                                child: Text(S.of(context).cancel, style: TextStyle(fontSize: ChatifySizes.fontSizeMd)),
                              ),
                              TextButton(
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
                      await _agoraCallService.leaveChannel();

                      try {
                        await _callService.endCall(widget.call.id);
                      } catch (e, st) {
                        log('[INCOMING_AUDIO] ❌ Failed to end call: $e', name: 'IncomingAudioCallScreen', error: e, stackTrace: st);
                      }

                      if (!mounted) return;

                      navigator.pop(CallResult(type: CallType.audio, status: CallStatusType.noAnswer));
                    },
                  )
                : IncomingCallControlPanel(
                    onAccept: _acceptCall,
                    onReject: _rejectCall,
                    onMessage: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const MessageAudioCallDialog();
                        },
                      );
                    },
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
