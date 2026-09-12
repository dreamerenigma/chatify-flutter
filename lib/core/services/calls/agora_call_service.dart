import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

class AgoraCallService extends GetxService {
  late final RtcEngine engine;
  bool _initialized = false;
  bool _joined = false;
  String? _currentChannel;

  bool get isInitialized => _initialized;
  bool get isJoined => _joined;
  String? get currentChannel => _currentChannel;

  Future<void> initialize({required String appId}) async {
    if (_initialized) {
      log('[AGORA] ⚠️ Already initialized', name: 'AgoraCallService');
      return;
    }

    log('[AGORA] 🔵 initialize()', name: 'AgoraCallService');

    engine = createAgoraRtcEngine();

    await engine.initialize(RtcEngineContext(appId: appId, channelProfile: ChannelProfileType.channelProfileCommunication));
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          _joined = true;
          _currentChannel = connection.channelId;

          log('[AGORA] 🟢 onJoinChannelSuccess ''channel=${connection.channelId} ''uid=${connection.localUid}', name: 'AgoraCallService');
        },

        onLeaveChannel: (connection, stats) {
          _joined = false;
          _currentChannel = null;
          log('[AGORA] 🔴 onLeaveChannel', name: 'AgoraCallService');
        },
        onError: (err, msg) {
          log('[AGORA] ❌ onError: $err / $msg', name: 'AgoraCallService');
        },
        onConnectionStateChanged: (connection, state, reason) {
          log(
            '[AGORA] 🔄 connectionStateChanged '
                'state=$state '
                'reason=$reason '
                'channel=${connection.channelId} '
                'uid=${connection.localUid}',
            name: 'AgoraCallService',
          );
        },
      ),
    );

    await engine.enableAudio();

    _initialized = true;
  }

  Future<void> joinChannel({
    required String channelName,
    required String token,
  }) async {
    if (!_initialized) {
      throw StateError('AgoraCallService is not initialized');
    }

    if (_joined) {
      throw StateError(
        'Already joined Agora channel: $_currentChannel',
      );
    }

    log(
      '[AGORA] 🔵 joinChannel: channel=$channelName',
      name: 'AgoraCallService',
    );

    log(
      '[AGORA] 🔎 BEFORE JOIN '
          'initialized=$_initialized '
          'joined=$_joined '
          'currentChannel=$_currentChannel',
      name: 'AgoraCallService',
    );

    log(
      '[AGORA] token empty=${token.isEmpty}',
      name: 'AgoraCallService',
    );

    try {
      await engine.joinChannel(
        token: token,
        channelId: channelName,
        uid: 0,
        options: const ChannelMediaOptions(
          publishMicrophoneTrack: true,
          autoSubscribeAudio: true,
        ),
      );

      log(
        '[AGORA] ✅ joinChannel request completed',
        name: 'AgoraCallService',
      );
    } catch (e, stackTrace) {
      log(
        '[AGORA] ❌ joinChannel ERROR: $e',
        name: 'AgoraCallService',
        error: e,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<bool> setSpeakerphone(bool enabled) async {
    if (!_initialized) {
      log('[AGORA] ❌ setSpeakerphone: engine not initialized', name: 'AgoraCallService');
      return false;
    }

    if (!_joined) {
      log('[AGORA] ❌ setSpeakerphone: not joined to channel', name: 'AgoraCallService');
      return false;
    }

    try {
      log('[AGORA] 🔊 setEnableSpeakerphone($enabled)', name: 'AgoraCallService');

      await engine.setEnableSpeakerphone(enabled);

      log('[AGORA] ✅ speakerphone changed: $enabled', name: 'AgoraCallService');

      return true;
    } catch (e, stackTrace) {
      log('[AGORA] ❌ setEnableSpeakerphone error: $e', name: 'AgoraCallService', error: e, stackTrace: stackTrace);

      return false;
    }
  }

  Future<void> mute(bool value) async {
    if (!_initialized) return;

    await engine.muteLocalAudioStream(value);
  }

  Future<void> leaveChannel() async {
    if (!_initialized) return;

    await engine.leaveChannel();
  }

  Future<void> disposeEngine() async {
    if (!_initialized) return;

    await engine.leaveChannel();
    await engine.release();

    _initialized = false;
  }
}
