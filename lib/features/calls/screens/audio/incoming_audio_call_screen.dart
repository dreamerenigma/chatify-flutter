import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../api/apis.dart';
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
import '../add_participants_screen.dart';
import '../video/outgoing_video_call_screen.dart';

class IncomingAudioCallScreen extends StatefulWidget {
  final CallModel call;
  final UserModel user;
  final VoidCallback? onMinimize;

  const IncomingAudioCallScreen({
    super.key,
    required this.call,
    required this.user,
    this.onMinimize,
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
  bool _isFinishing = false;
  bool _showConnectionText = false;
  bool _isLoadingProfileImage = false;
  String? _profileImageUrl;
  StreamSubscription<CallModel>? _callSubscription;
  Timer? _callTimer;
  DateTime? _acceptedAt;
  Duration _callDuration = Duration.zero;

  String _formatCallDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    AgoraTokenService.testServer();
    audioPlayer = AudioPlayer();
    prepareAgora();
    _listenCall();
    _loadProfileImage();
  }

  @override
  void dispose() {
    _callSubscription?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  void _startCallTimer(DateTime acceptedAt) {
    _callTimer?.cancel();

    _acceptedAt = acceptedAt;

    _updateCallDuration();

    _callTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _updateCallDuration();
      },
    );
  }

  void _updateCallDuration() {
    if (!mounted || _acceptedAt == null) return;

    final duration = DateTime.now().difference(_acceptedAt!);

    setState(() {
      _callDuration = duration;
    });
  }

  void _listenCall() {
    log(
      '[INCOMING_AUDIO] 🔵 Listening call: ${widget.call.id}',
      name: 'IncomingAudioCallScreen',
    );

    _callSubscription = _callService.observeCall(widget.call.id).listen((call) async {
      log('[INCOMING_AUDIO] Call state: ${call.state.name}', name: 'IncomingAudioCallScreen');

      switch (call.state) {
        case CallStateType.ringing:
          break;
        case CallStateType.accepted:
          log('[INCOMING_AUDIO] ✅ Call accepted', name: 'IncomingAudioCallScreen');
          if (call.acceptedAt != null) {
            _startCallTimer(call.acceptedAt!);
          }
          if (mounted) {
            setState(() {
              _isCallAccepted = true;
            });
          }
          break;
        case CallStateType.rejected:
          log('[INCOMING_AUDIO] ❌ Call rejected', name: 'IncomingAudioCallScreen');
          await _finishCall(CallStatusType.rejected);
          break;
        case CallStateType.ended:
          log('[INCOMING_AUDIO] 🔴 Call ended by other side', name: 'IncomingAudioCallScreen');
          await _finishCall(CallStatusType.noAnswer);
          break;
      }
    });
  }

  Future<void> _loadProfileImage() async {
    final imagePath = widget.user.image.trim();

    if (imagePath.isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingProfileImage = true;
      });
    }

    try {
      final url = await APIs.getMediaUrl(imagePath);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = url;
        _isLoadingProfileImage = false;
      });
    } catch (e, stackTrace) {
      log('PROFILE IMAGE URL ERROR: $e', stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _profileImageUrl = null;
        _isLoadingProfileImage = false;
      });
    }
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

  Future<void> _finishCall(CallStatusType status) async {
    if (_isFinishing) {
      log('[INCOMING_AUDIO] ⚠️ Already finishing call', name: 'IncomingAudioCallScreen');
      return;
    }

    _isFinishing = true;

    log('[INCOMING_AUDIO] 🔴 Finishing call: ${status.name}', name: 'IncomingAudioCallScreen');

    await _stopRingingTone();
    await _callSubscription?.cancel();
    _callSubscription = null;

    if (_agoraCallService.isJoined) {
      log('[INCOMING_AUDIO] 🔴 Leaving Agora channel', name: 'IncomingAudioCallScreen');

      await _agoraCallService.leaveChannel();
    }

    if (!mounted) return;

    log('[INCOMING_AUDIO] 🟣 Navigator.pop()', name: 'IncomingAudioCallScreen');

    Navigator.pop(context, CallResult(type: CallType.audio, status: status));
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
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: SizedBox(
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
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child:  _isCallAccepted
                          ? Column(
                              children: [
                                Text(
                                  '${widget.user.name} ${widget.user.surname}',
                                  style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400), textAlign: TextAlign.center,
                                ),
                                Text(
                                  _formatCallDuration(_callDuration),
                                  key: const ValueKey('call_duration'),
                                  style: TextStyle(
                                    color: ChatifyColors.darkGrey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color.fromARGB(128, 0, 0, 0))],
                                  ),
                                ),
                              ],
                            )
                          : _showConnectionText
                            ? Column(
                                children: [
                                  Text(
                                    '${widget.user.name} ${widget.user.surname}',
                                    style: TextStyle(color: ChatifyColors.white, fontSize: ChatifySizes.fontSizeLg, fontWeight: FontWeight.w400), textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Соединение...',
                                    key: const ValueKey('connecting'),
                                    style: TextStyle(
                                      color: ChatifyColors.darkGrey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color.fromARGB(128, 0, 0, 0))],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                key: const ValueKey('user_info'),
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
                    ),
                  ],
                ),
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
                    imageUrl: _profileImageUrl ?? '',
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
          _isCallAccepted
            ? Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CallControlPanel(
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
                      if (_isFinishing) return;

                      log('[INCOMING_AUDIO] 🔴 END BUTTON PRESSED', name: 'IncomingAudioCallScreen');

                      await playClickButton(audioPlayer);

                      try {
                        log('[INCOMING_AUDIO] 🔴 Calling endCall: ${widget.call.id}', name: 'IncomingAudioCallScreen');

                        await _callService.endCall(widget.call.id);

                        log('[INCOMING_AUDIO] ✅ endCall completed', name: 'IncomingAudioCallScreen');
                      } catch (e, st) {
                        log('[INCOMING_AUDIO] ❌ Failed to end call: $e', name: 'IncomingAudioCallScreen', error: e, stackTrace: st);
                      }

                      await _finishCall(CallStatusType.noAnswer);
                    },
                  ),
              )
            : Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                  child: IncomingCallControlPanel(
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
                ),
        ],
      ),
    );
  }
}
