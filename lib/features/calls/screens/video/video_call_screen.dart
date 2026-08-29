import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../../utils/constants/app_colors.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  VideoCallScreenState createState() => VideoCallScreenState();
}

class VideoCallScreenState extends State<VideoCallScreen> with TickerProviderStateMixin {
  late RTCVideoRenderer localRenderer;
  late RTCVideoRenderer remoteRenderer;
  RTCPeerConnection? peerConnection;
  MediaStream? localStream;

  late AnimationController moveController;
  late Animation<double> moveAnimation;
  bool isRotated = false;
  OverlayEntry? floatingButtonOverlay;

  @override
  void initState() {
    super.initState();
    initRenderers();
    moveController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    moveAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: moveController, curve: Curves.easeInOut));
    initLocalStream();
  }

  Future<void> initRenderers() async {
    localRenderer = RTCVideoRenderer();
    remoteRenderer = RTCVideoRenderer();
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future<void> initLocalStream() async {
    localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });
    localRenderer.srcObject = localStream;

    final configuration = {'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]};
    peerConnection = await createPeerConnection(configuration);

    if (localStream != null) {
      localStream!.getTracks().forEach((track) {
        peerConnection!.addTrack(track, localStream!);
      });
    }

    peerConnection!.onTrack = (event) {
      if (event.streams.isNotEmpty) {
        setState(() {
          remoteRenderer.srcObject = event.streams[0];
        });
      }
    };
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    peerConnection?.close();
    moveController.dispose();
    floatingButtonOverlay?.remove();
    super.dispose();
  }

  void _showBottomSheet(BuildContext context) {
    moveController.forward();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(20), backgroundColor: ChatifyColors.green),
                child: const Icon(Icons.video_call, color: ChatifyColors.white),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(20), backgroundColor: ChatifyColors.blue),
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
                angle: isRotated ? 3.14 : 0,
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
          Positioned.fill(child: RTCVideoView(remoteRenderer)),
          Positioned(
            right: 16,
            top: 16,
            width: 120,
            height: 160,
            child: RTCVideoView(localRenderer, mirror: true),
          ),
        ],
      ),
    );
  }
}
