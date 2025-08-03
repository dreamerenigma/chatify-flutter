import 'dart:math';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../../../utils/constants/app_colors.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  VideoCallScreenState createState() => VideoCallScreenState();
}

class VideoCallScreenState extends State<VideoCallScreen> with TickerProviderStateMixin {
  final String appId = "d0817c9204894d838d4be66706170830";
  final String channelName = "main_channel";
  final String token = "007eJxTYJjGYiVXOFVugd2KrbMvbVm/TeLFlz2HKp991D0WX7V3l+ZsBYYUAwtD82RLIwMTC0uTFAtjixSTpFQzM3MDM0NzAwtjg5vyE9IaAhkZ2MpuMjEyQCCIz8OQm5iZF5+ckZiXl5rDwAAAuzcjZA==";

  late final RtcEngine engine;
  late AnimationController moveController;
  late Animation<double> moveAnimation;
  bool isRotated = false;
  OverlayEntry? floatingButtonOverlay;

  @override
  void initState() {
    super.initState();
    moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    moveAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: moveController,
      curve: Curves.easeInOut,
    ));

    initialize();
  }

  Future<void> initialize() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
    ));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("Local user ${connection.localUid} joined");
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print("Remote user $remoteUid joined");
          setState(() {});
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          print("Remote user $remoteUid left channel");
          setState(() {});
        },
      ),
    );

    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    engine.leaveChannel();
    engine.release();
    moveController.dispose();
    floatingButtonOverlay?.remove();
    super.dispose();
  }

  void _showBottomSheet(BuildContext context) {
    moveController.forward();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  backgroundColor: ChatifyColors.green,
                ),
                child: const Icon(Icons.video_call, color: ChatifyColors.white),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  backgroundColor: ChatifyColors.blue,
                ),
                child: const Icon(Icons.phone, color: ChatifyColors.white),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        isRotated = !isRotated;
      });
      moveController.reverse();
    });
  }

  OverlayEntry _createFloatingButtonOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16 + (moveAnimation.value * 200),
        left: 0,
        right: 0,
        child: Center(
          child: AnimatedBuilder(
            animation: moveController,
            builder: (context, child) {
              double bottomOffset = MediaQuery.of(context).viewInsets.bottom + 16 + (moveAnimation.value * 200);
              return Transform.rotate(
                angle: isRotated ? pi : 0,
                child: Container(margin: EdgeInsets.only(bottom: bottomOffset), child: child),
              );
            },
            child: RawMaterialButton(
              onPressed: () {
                setState(() {
                  isRotated = !isRotated;
                });
                _showBottomSheet(context);
              },
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              fillColor: ChatifyColors.transparent,
              elevation: 0,
              highlightElevation: 0,
              child: const Icon(Icons.keyboard_arrow_down_rounded, color: ChatifyColors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (floatingButtonOverlay == null) {
      floatingButtonOverlay = _createFloatingButtonOverlay();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Overlay.of(context).insert(floatingButtonOverlay!);
      });
    }
    return Scaffold(
      body: Stack(
        children: [
          _renderLocalPreview(),
          _renderRemoteVideo(),
        ],
      ),
    );
  }

  Widget _renderLocalPreview() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget _renderRemoteVideo() {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: engine,
        canvas: const VideoCanvas(uid: 1),
        connection: const RtcConnection(channelId: "main_channel"),
      ),
    );
  }
}
